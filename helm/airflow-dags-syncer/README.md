# Setup

* Initialize Tiller:
```
$ kubectl apply -f helm-rbac.yaml
$ helm init --service-account tiller
```

* Check that Tiller Pod(s) are running:
```
$ kubectl -n kube-system get pods -l name=tiller
```

* Update the Helm deploy helper script:
```
$ cat deploy-helm-chart.sh
#!/bin/bash
export PROJECT=wotc  # aka "envrionment" (e.g., dev, stage, prod)
export AWS_ACCOUNT_ID=000000000000
export AWS_REGION=us-west-2
export IMAGE_NAME=wotc-airflow-dags
export IMAGE_TAG=latest
export IMAGE_REPOSITORY=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}
helm upgrade --install ${PROJECT} . \
  -f values-dev.yaml \
  --set=image.repository=${IMAGE_REPOSITORY} \
  --set=image.tag=${IMAGE_TAG} \
  --debug --dry-run
```

* Deploy the Helm Chart:
```
$ ./deploy-helm-chart.sh
```
