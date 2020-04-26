# Multi-stage build : cf. https://docs.docker.com/develop/develop-images/multistage-build/
#   1) retrieve tools sush as terraform using curl and co
#   2) build image from alpine:3.10.4
#
FROM alpine as build

ARG TERRAFORM_VERSION
ARG BUILD_DATE

RUN apk add --update --no-cache ca-certificates \
    curl \
    unzip

WORKDIR /tmp

RUN mkdir -p /tmp/build \
  && curl -sfLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip -d /tmp/build /tmp/terraform.zip \
  && chmod +x /tmp/build/*

FROM alpine:3.10.4

ARG AWSCLI_VERSION
ARG ANSIBLE_VERSION

WORKDIR /root

# Metadata
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

RUN apk add --update --no-cache ca-certificates \
    curl \
    libintl  \
    gettext \
    git \
    libc6-compat \
    jq \
    python3 \
    make

# Add required dependencies for ansible
RUN apk add --update --no-cache ca-certificates --virtual build-dependencies \
    libffi-dev \
    openssl-dev \ 
    build-base \
    gcc \
    python3-dev \
    musl-dev

RUN ln -sf /usr/bin/envsubst /usr/local/bin/envsubst
# Force Python 3 as default Python
RUN ln -sf /usr/bin/python3 /usr/bin/python

COPY requirements.txt .

RUN pip3 install --upgrade pip cffi
RUN pip3 install -r requirements.txt
RUN pip3 install "awscli==${AWSCLI_VERSION}" 
RUN pip3 install "ansible==${ANSIBLE_VERSION}"

RUN chmod a+x /usr/local/bin/*
COPY --from=build /tmp/build/* /usr/local/bin/

ENTRYPOINT ["/bin/bash","-c"]