from fastapi import FastAPI
from pydantic import BaseModel
from transformers import pipeline

app = FastAPI()
generator = pipeline("text-generation", model="gpt2")

class Message(BaseModel):
    role: str
    content: str

class RequestBody(BaseModel):
    messages: list[Message]

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/completion")
def complete(request: RequestBody):
    try:
        input_text = request.messages[-1].content
        response = generator(input_text, max_length=50, num_return_sequences=1)
        return {
            "status": "success",
            "response": [{"role": "assistant", "message": response[0]['generated_text']}]
        }
    except Exception as e:
        return { "status": "error", "message": str(e) }