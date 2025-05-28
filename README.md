## Tony Blair institute devops assessment
This repository contains infrastructure as code, a serving application, monitoring stack, and CI/CD pipeline for a machine learning model serving solution. The code will promote a fullu automated devops pipeline.

## Project Structure

```
iac/
  └── # All Terraform, Kubernetes, and infra code (e.g., .tf, .yaml files)
serving/
  └── # All application source code (e.g., main.py, Dockerfile, requirements.txt)
tests/
  └── # All unit tests for your application (e.g., test_main.py)
README.md
```

---

## Prerequisites

This project deploys a 
- **Terraform** for cluster setup.
- **Docker** for containerizing the application
- **GitHub Actions** for CI/CD
- **Prometheus & Grafana** for monitoring
- **Kind** for local testing

---


## Infrastructure Deployment

1. **Initialize and apply Terraform for s3 bucket to capture state file:**
   ```sh
   cd iac/deploy/s3
   terraform init
   terraform apply --auto-approve
  
  repeat for actual infrastructure
 
1. **repeat for actual infrastucture:**
   ```sh
   cd iac/deploy/
   terraform init
   terraform apply --auto-approve

2. **(Optional) For local testing with Kind:**
   ```sh
   kind create cluster --name tonyblair --config kind-config.yaml
   ```

---

## Application Build & Deployment

1. **Build and push Docker image:**
   ```sh
   docker build -t tonyblair-repository:1.0 -f Dockerfile .
   docker push tonyblair-repository:1.0
   ```
   Replace `tonyblair-repository` with your actual ECR repository URI.

2. **Update image in `K8s/deployment.yaml` if needed.**

3. **Apply Kubernetes manifests:**
   ```sh
   kubectl apply -f K8s/namespace.yaml
   kubectl apply -f K8s/deployment.yaml
   kubectl apply -f K8s/service.yaml
   
   kubectl apply -f K8s/ingress.yaml
   ```

---

## Monitoring

- **Prometheus** and **Grafana** are deployed in the `monitoring` namespace using Helm.

### Install Prometheus and Grafana with Helm

1. **Add Helm repositories:**
   ```sh
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo add grafana https://grafana.github.io/helm-charts
   helm repo update
   ```

2. **Create the monitoring namespace:**
   ```sh
   kubectl create namespace monitoring
   ```

3. **Install Prometheus:**
   ```sh
   helm install prometheus prometheus-community/prometheus --namespace monitoring
   ```

4. **Install Grafana:**
   ```sh
   helm install grafana grafana/grafana --namespace monitoring --set adminPassword='admin'
   ```

### Access Grafana:
```sh
kubectl port-forward svc/grafana 3000:3000 -n monitoring
```
Visit [http://localhost:3000](http://localhost:3000) in your browser.  
Default login: `admin` / `admin`

### Access Prometheus:
```sh
kubectl port-forward svc/prometheus-server 9090:80 -n monitoring
```
Visit [http://localhost:9090](http://localhost:9090).

---

## Ingress

- Ingress is configured for local testing.
- Add to your `/etc/hosts`:
  ```
  127.0.0.1 tonyblair.local
  ```
- Access your app at [http://tonyblair.local](http://tonyblair.local).

---

## CI/CD

- GitHub Actions workflow is defined in `.github/workflows/deploy.yaml`.
- Pipeline includes linting, testing, Docker build/push, and Kubernetes deployment.

---

## Testing & Linting

Run locally or via GitHub Actions:

```sh
pip install -r serving/requirements.txt
pytest tests/
flake8 serving/
yamllint K8s/
```

---

## API Endpoints

- **POST `/inference`**  
  Request:  
  ```json
  { "messages": [ {"role": "user", "content": "message"} ] }
  ```
  Response:  
  ```json
  { "status": "success", "response": [ {"role": "assistant", "message": "response"} ] }
  ```

- **GET `/status`**  
  Response:  
  ```json
  { "status": "NOT_DEPLOYED" | "PENDING" | "DEPLOYING" | "RUNNING" }
  ```

- **GET `/model`**  
  Response:  
  ```json
  { "model_id": "model name" }
  ```

- **POST `/deploy`**  
  Request:  
  ```json
  { "model_id": "model name" }
  ```
  Response:  
  ```json
  { "status": "success", "model_id": "model name" }
  ```

---

## Notes

- This Ingress assumes you have an NGINX Ingress Controller installed in your cluster.
- Update the `host` field as needed for your environment.
- For local testing, add `127.0.0.1 tonyblair.local` to your `/etc/hosts` file.
- Adjust service names and ports if they differ in your manifests.

---

**For any issues, check logs with:**
```sh
kubectl logs deployment/<deployment-name> -n monitoring
```
and
```sh
kubectl get all -n monitoring
```