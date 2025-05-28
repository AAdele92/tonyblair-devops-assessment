ROM python:3.9-alpine3.13

WORKDIR /app
COPY serving/ /app

RUN pip install --no-cache-dir fastapi uvicorn transformers prometheus-fastapi-instrumentator

EXPOSE 80
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]