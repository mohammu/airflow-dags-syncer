#!/bin/bash
AWS_REGION=us-west-2
CODECOMMIT_URL=https://git-codecommit.us-west-2.amazonaws.com/v1/repos/wotc-airflow-dags
ECR_ENDPOINT=771502366784.dkr.ecr.us-west-2.amazonaws.com/wotc-airflow-dags
IMAGE_NAME=wotc-airflow-dags
IMAGE_TAG=latest

$(aws ecr get-login --no-include-email --region ${AWS_REGION})
#docker build --no-cache --build-arg AWS_CODECOMMIT_URL=${CODECOMMIT_URL} -t ${IMAGE_NAME}:${IMAGE_TAG} .
docker build --build-arg AWS_CODECOMMIT_URL=${CODECOMMIT_URL} -t ${IMAGE_NAME}:${IMAGE_TAG} .
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_ENDPOINT}:${IMAGE_TAG}
docker push ${ECR_ENDPOINT}:${IMAGE_TAG}
