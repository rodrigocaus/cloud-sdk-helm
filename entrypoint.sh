#!/bin/bash

# Tries to read values from environment. Default is fetched from gcloud
cluster=${CLOUDSDK_CONTAINER_CLUSTER:-$(gcloud config get-value container/cluster 2> /dev/null)}
region=${CLOUDSDK_COMPUTE_REGION:-$(gcloud config get-value compute/region 2> /dev/null)}
zone=${CLOUDSDK_COMPUTE_ZONE:-$(gcloud config get-value compute/zone 2> /dev/null)}
project=${GCLOUD_PROJECT:-$(gcloud config get-value core/project 2> /dev/null)}

if [ -z "$cluster" ]; then
    echo "No cluster configured. To set the cluster, set the environment variables:"
    echo "CLOUDSDK_CONTAINER_CLUSTER=<cluster name>"
    exit 1
fi

if [ ! "$zone" -o "$region" ]; then
    echo "No region/zone defined. To set compute zone or region, set one of the environment variables"
    echo "CLOUDSDK_COMPUTE_REGION=<cluster region> (for regional clusters)"
    echo "CLOUDSDK_COMPUTE_ZONE=<cluster zone> (for zonal clusters)"
    exit 1
fi

if [ "$region" ]; then
    region_or_zone=--region="$region"
else
    region_or_zone=--zone="$zone"
fi

gcloud container clusters get-credentials "$cluster" --project="$project" "$region_or_zone"
if [[ $? -ne 0 ]]; then
    echo "Error on get kubectl credentials from Google Cloud"
    exit 1
fi

# Check external repository
if [ "$HELM_REPO_NAME" -a "$HELM_REPO_URL" ]; then
    echo "Adding chart helm repo $HELM_REPO_NAME at $HELM_REPO_URL"
    helm repo add $HELM_REPO_NAME $HELM_REPO_URL
    helm repo update
    helm repo list
fi

helm "$@"
