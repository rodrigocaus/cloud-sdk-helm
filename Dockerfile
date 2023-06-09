FROM google/cloud-sdk:alpine

COPY entrypoint.sh /builder/helm.sh

ARG HELM_GCS_VERSION='0.4.1'

RUN gcloud config set disable_prompts true \
    && gcloud components install gsutil kubectl \
    && rm -rf $(find /google-cloud-sdk/ -regex ".*/__pycache__") \
    && rm -rf /google-cloud-sdk/.install/.backup \
    && apk add --no-cache helm --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    && helm repo add "stable" "https://charts.helm.sh/stable" --force-update \
    && helm plugin install https://github.com/hayorov/helm-gcs.git --version ${HELM_GCS_VERSION} \
    && chmod +x /builder/helm.sh

WORKDIR /workspace

ENTRYPOINT ["/builder/helm.sh"]
