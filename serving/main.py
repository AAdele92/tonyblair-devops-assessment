from fastapi import FastAPI
from pydantic import BaseModel
from transformers import pipeline
from typing import List, Optional

app = FastAPI()

# State for model management
class ModelState:
    def __init__(self):
        self.model_id = "gpt2"
        self.status = "NOT_DEPLOYED"
        self.generator = None

    def deploy(self, model_id: str):
        self.status = "PENDING"
        try:
            self.generator = pipeline("text-generation", model=model_id)
            self.model_id = model_id
            self.status = "RUNNING"
            return True, ""
        except Exception as e:
            self.status = "NOT_DEPLOYED"
            return False, str(e)

model_state = ModelState()
model_state.deploy("gpt2")  # Deploy default model at startup

class Message(BaseModel):
    role: str
    content: str

class RequestBody(BaseModel):
    messages: List[Message]

class DeployRequest(BaseModel):
    model_id: str

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/inference")
def inference(request: RequestBody):
    if model_state.status != "RUNNING" or not model_state.generator:
        return {"status": "error", "message": "No model is currently running."}
    try:
        input_text = request.messages[-1].content
        response = model_state.generator(input_text, max_length=50, num_return_sequences=1)
        return {
            "status": "success",
            "response": [{"role": "assistant", "message": response[0]['generated_text']}]
        }
    except Exception as e:
        model_state.status = "NOT_DEPLOYED"
        return {"status": "error", "message": str(e)}

@app.get("/status")
def status():
    return {"status": model_state.status}

@app.get("/model")
def model_info():
    return {"model_id": model_state.model_id}

@app.post("/deploy")
def deploy_model(request: DeployRequest):
    model_state.status = "PENDING"
    success, error = model_state.deploy(request.model_id)
    if success:
        return {"status": "success", "model_id": model_state.model_id}
    else:
        return {"status": "error", "message": error}