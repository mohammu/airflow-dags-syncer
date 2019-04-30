#!/bin/bash
$(aws ecr get-login --no-include-email --region us-west-2)
docker build --build-arg AWS_CODECOMMIT_URL=https://git-codecommit.us-west-2.amazonaws.com/v1/repos/wotc-airflow-dags -t wotc-airflow-dags .
docker tag wotc-airflow-dags:latest 771502366784.dkr.ecr.us-west-2.amazonaws.com/wotc-airflow-dags:latest
docker push 771502366784.dkr.ecr.us-west-2.amazonaws.com/wotc-airflow-dags:latest
