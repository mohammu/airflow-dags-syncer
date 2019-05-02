# Prerequisites (before setup)

* Create your Kubernetes Secrets manifest (this YAML stores your AWS credentials, so do _not_ commit these to the repository):
```
$ cp secret-aws-credentials-template.yaml local-secret-aws-credentials.yaml
$ cat local-secret-aws-credentials.yaml
apiVersion: v1
kind: Secret
metadata:
  # NOTE: Change "wotc" to your project name
  name: wotc-airflow-dags-syncer-secrets
type: Opaque
data:
  # This is the contents of your ~/.aws/credentials file (base64 encoded):
  credentials: <base64 encoded aws credentials file>
```

* Make changes to the Helm Chart deploy helper script:
```
$ cp deploy-helm-chart.sh local-deploy-helm-chart.sh
$ cat local-deploy-helm-chart.sh
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
  --debug --dry-run  # <- NOTE
```
NOTE: The `--dry-run` flag will not deploy anything. Remove it when you are ready to actually deploy. The dry run is there to validate that everything has been configured properly.

* Make changes to the `values.yaml` file:
```
$ cp values.yaml values-dev.yaml
```
NOTE: Make your actual changes to the above copied file.

# Setup

After you have completed the above prerequisites, you are now ready to deploy your Helm Chart.

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
