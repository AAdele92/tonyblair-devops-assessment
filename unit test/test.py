from fastapi.testclient import TestClient
from serving.main import app

client = TestClient(app)

def test_inference_success():
    response = client.post("/inference", json={"messages": [{"role": "user", "content": "hello"}]})
    assert response.status_code == 200
    assert response.json()["status"] == "success"

def test_status_endpoint():
    response = client.get("/status")
    assert response.status_code == 200
    assert "status" in response.json()

def test_model_info():
    response = client.get("/model")
    assert response.status_code == 200
    assert "model_id" in response.json()

def test_deploy_success():
    response = client.post("/deploy", json={"model_id": "distilbert-base-uncased"})
    assert response.status_code == 200
    assert response.json()["status"] in ["success", "error"]