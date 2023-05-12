FROM mcr.microsoft.com/windows/servercore:ltsc2019

# ---------------------------------------------
# Chocolatey Package Manager
# ---------------------------------------------
RUN @powershell [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
ENV chocolateyUseWindowsCompression=false
RUN @powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco config set cachelocation C:\chococache
RUN choco feature enable --name allowGlobalConfirmation 

# ---------------------------------------------
# Chocolatey Packages
# ---------------------------------------------
RUN choco install git;
RUN choco install jdk8;
RUN choco install nodejs-lts;
RUN choco install maven;
RUN choco install curl;
RUN choco install docker;
RUN choco install terraform;
RUN choco install terraform-docs;
RUN choco install openssl;
RUN choco install wget;
RUN choco install dotnet-6.0-sdk;
RUN choco install dotnetcore-sdk;
RUN choco install azure-cli;

# ---------------------------------------------
# Chocolatey Clear Cache
# ---------------------------------------------
RUN rmdir /S /Q C:\chococache

WORKDIR /azp

COPY start.ps1 .

CMD powershell .\start.ps1