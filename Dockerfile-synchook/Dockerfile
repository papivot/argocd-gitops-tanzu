FROM ubuntu:22.04
RUN apt-get update \
    && apt-get install -y vim curl wget apt-transport-https gnupg2 jq gettext-base\
    && apt-get -y upgrade\
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl

ADD https://github.com/mikefarah/yq/releases/download/v4.35.2/yq_linux_amd64 /usr/local/bin/yq

COPY script.sh /
COPY argocd-secret.template.yaml /
# COPY argocd-tkc-addons.template.yaml /

RUN chmod 755 /script.sh \
    && chmod +x /usr/local/bin/yq

USER root
WORKDIR /