FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends docker.io git wget curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY kp /usr/bin/kp
COPY kubectl /usr/bin/kubectl
COPY kapp /usr/bin/kapp
COPY ytt /usr/bin/ytt

ENTRYPOINT [ "echo hello" ]