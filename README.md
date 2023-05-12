# Cloud SDK Helm

Helm builder tool to deploy charts to GKE on CI/CD pipelines. It is heavily based on 
[cloud-builders-community](https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/helm), but
already have GCS plugin and uses Helm v3 by default (without tiller deploy)


## Building

Run `docker build` to get a local container:

```bash
$ docker build -t cloud-sdk-helm .
```

## Running locally

You can run it locally by mouting your local gcloud config path:

```bash
$ docker run -v "$HOME/.config/gcloud":/var/run/gcloud -e CLOUDSDK_CONFIG=/var/run/gcloud --env-file .env \
         cloud-sdk-helm list --all-namespaces
```

Set running variable environments on `.env` file:
```
GCLOUD_PROJECT=<project-id>
CLOUDSDK_COMPUTE_ZONE=<your-compute-zone>
CLOUDSDK_COMPUTE_REGION=<your-compute-region>
CLOUDSDK_CONTAINER_CLUSTER=<your-kubernetes-cluster-name>
```

You can also add external Chart repositories by setting:
```env
HELM_REPO_NAME=<aditional-chart-repo>
HELM_REPO_URL=<aditional-chart-repo-url>
```
