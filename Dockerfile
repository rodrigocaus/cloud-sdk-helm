FROM google/cloud-sdk:alpine

COPY entrypoint.sh /builder/helm.sh

RUN gcloud config set disable_prompts true \
    && gcloud components install gsutil kubectl \
    && apk add helm --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    && helm repo add "stable" "https://charts.helm.sh/stable" --force-update \
    && helm plugin install https://github.com/hayorov/helm-gcs.git \
    && chmod +x /builder/helm.sh

WORKDIR /workspace

ENTRYPOINT ["/builder/helm.sh"]
