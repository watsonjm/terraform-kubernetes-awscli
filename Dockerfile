FROM ubuntu:18.04

ARG TERRAFORM_VERSION="0.13.4"

LABEL terraform_version=${TERRAFORM_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}

# Installing CircleCI pre-reqs
RUN apt-get update && apt-get install -y apt-utils git gzip tar openssh-server ca-certificates openssl curl zip

# Installing AWS CLI
RUN apt-get -y install awscli

# Installing k8s
RUN  apt-get update &&  apt-get install -y apt-transport-https gnupg2 curl \
	&& curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add - \
	&& echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list \
	&& apt-get update \
	&& apt-get install -y kubectl

# Installing Helm
RUN curl https://baltocdn.com/helm/signing.asc | apt-key add - \
    && apt-get install apt-transport-https --yes \
    && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update \
    && apt-get install helm

# Installing Terraform
RUN apt-get update \
    && curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip '*.zip' -d /usr/local/bin \
    && rm *.zip

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD    ["/bin/bash"]
