FROM python:3.9-alpine3.13

WORKDIR /app
COPY . /app

RUN pip install fastapi uvicorn transformers

EXPOSE 80
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]