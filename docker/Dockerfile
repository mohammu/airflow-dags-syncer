FROM python:3.6-slim
#FROM python:2.7-slim

LABEL maintainer="christoph.champ@gmail.com"

ARG AWS_CODECOMMIT_URL
ENV aws_codecommit_url=$AWS_CODECOMMIT_URL

RUN apt-get update -y \
    && apt-get install -y git \
    && pip install -U pip setuptools wheel awscli boto3 dirsync \
    && mkdir -p /root/.aws /app /data

COPY app /app/
WORKDIR /app

CMD ["python", "run.py"]
