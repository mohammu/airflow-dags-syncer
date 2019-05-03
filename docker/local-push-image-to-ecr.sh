#!/bin/bash
AWS_ACCOUNT_ID=771502366784
AWS_REGION=us-west-2
IMAGE_NAME=wotc-airflow-dags
IMAGE_TAG=latest
CODECOMMIT_URL=https://git-codecommit.${AWS_REGION}.amazonaws.com/v1/repos/${IMAGE_NAME}
ECR_ENDPOINT=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}

$(aws ecr get-login --no-include-email --region ${AWS_REGION})
#docker build --no-cache --build-arg AWS_CODECOMMIT_URL=${CODECOMMIT_URL} -t ${IMAGE_NAME}:${IMAGE_TAG} .
docker build --build-arg AWS_CODECOMMIT_URL=${CODECOMMIT_URL} -t ${IMAGE_NAME}:${IMAGE_TAG} .
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_ENDPOINT}:${IMAGE_TAG}
docker push ${ECR_ENDPOINT}:${IMAGE_TAG}
