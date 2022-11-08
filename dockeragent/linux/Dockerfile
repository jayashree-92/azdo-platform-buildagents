FROM ubuntu:20.04

# ---------------------------------------------
# Variables
# ---------------------------------------------
ARG TERRAFORM_VERSION=1.3.3

# ---------------------------------------------
# Ubuntu Update and Upgrade Repositories
# ---------------------------------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# ---------------------------------------------
# Install Built-In Packages (Latest)
# ---------------------------------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common \
    wget \
    zip \
    unzip \
    openssh-client \
    python \
    pip

# ---------------------------------------------
# Install Azure CLI (Latest)
# ---------------------------------------------
RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN add-apt-repository universe
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# ---------------------------------------------
# Install Terraform CLI (Version from ARG)
# ---------------------------------------------
RUN wget --progress=dot:mega https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN \
	echo "Installing Terraform ${TERRAFORM_VERSION}..." && \
	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	mv terraform /usr/local/bin/ && \
	chmod +x /usr/local/bin/terraform


# ---------------------------------------------
# Ansible CLI (Latest)
# ---------------------------------------------
RUN \
    add-apt-repository --yes --update ppa:ansible/ansible && \
    apt-get update && \
    apt-get install ansible -y

# ---------------------------------------------
# SQLCMD CLI (Latest)
# ---------------------------------------------
RUN ACCEPT_EULA=Y apt-get install mssql-tools unixodbc-dev -y

RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc


# ---------------------------------------------
# PowerShell Core CLI (Latest)
# ---------------------------------------------
RUN apt-get install -y powershell -y

# ---------------------------------------------
# YQ CLI (Latest)
# ---------------------------------------------
RUN \
    wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod a+x /usr/local/bin/yq

# ---------------------------------------------
# Terra-Docs Setup (Latest)
# ---------------------------------------------
RUN \
    curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz && \
    tar -xzf terraform-docs.tar.gz && \
    chmod +x terraform-docs && \
    mv terraform-docs /usr/local/bin/terraform-docs

# ---------------------------------------------
# Checkov for Terraform (Latest)
# ---------------------------------------------
RUN pip --no-input install checkov 

# ---------------------------------------------
# Docker Configuration
# ---------------------------------------------
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]