FROM ubuntu:20.04

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
    pip \
    vim \
    dnsutils \
    gnupg


# ---------------------------------------------
# Install Azure CLI (Latest)
# ---------------------------------------------
RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN add-apt-repository universe
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# ---------------------------------------------
# Install .NET SDKs (For DevOps Security Extension)
# ---------------------------------------------
RUN apt-get update && \
    apt-get install -y dotnet-sdk-6.0 dotnet-sdk-3.1

# ---------------------------------------------
# Install Terraform CLI (Version from ARG)
# ---------------------------------------------

RUN \
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

RUN \
    apt-get update && \
    apt-get install terraform

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
# Install urllib3 (Version 1.26.0 or higher)
# ---------------------------------------------
RUN python3 -m pip install urllib3==1.26.7
RUN python3 -c "import urllib3; print(urllib3.__version__)"


# ---------------------------------------------
# Install certifi (Version 2023.7.22 or higher)
# ---------------------------------------------
RUN python3 -m pip install certifi>=2024.2.2
RUN python3 -c "import certifi; print(certifi.__version__)"


# ---------------------------------------------
# Install cryptography (Version 39.0.1 or higher)
# ---------------------------------------------
RUN  python3 -m pip install --upgrade cryptography>=42.0.0
RUN  python3 -c "import cryptography; print(cryptography.__version__)"

# ---------------------------------------------
# Install wheel (Version 0.38.1 or higher)
# ---------------------------------------------
RUN  python3 -m pip install --upgrade wheel>=0.38.1
RUN  python3 -c "import wheel; print(wheel.__version__)"

# ---------------------------------------------
# Install jinja2 (Version 3.1.3 or higher)
# ---------------------------------------------
RUN python3 -m pip install --upgrade jinja2>=3.1.3
RUN python3 -c "import jinja2; print(jinja2.__version__)"

# ---------------------------------------------
# Active Directory Library for Python
# ---------------------------------------------
RUN python3 -m pip install ms_active_directory
#RUN python3 -c "import ms_active_directory"
#RUN python3 -c "from ms_active_directory import ADDomain"
# ---------------------------------------------
# AWX CLI for Ansible (Latest)
# ---------------------------------------------
# RUN pip --no-input install awxkit 
RUN python3 -m pip install --upgrade awxkit
RUN python3 -c "import awxkit"

# ---------------------------------------------
# Ansible install
#------------------------------------------------
RUN pip install --no-cache-dir ansible>=2.16.3
RUN ansible --version

# ---------------------------------------------
# Install ansible-core (Version 2.14.14 or higher)
# ---------------------------------------------
RUN pip install --upgrade ansible-core>=2.14.14
RUN ansible --version

# ---------------------------------------------
# Docker Configuration
# ---------------------------------------------
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]