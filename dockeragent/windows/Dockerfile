# escape=`

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
RUN choco install curl;
RUN choco install git;
RUN choco install jdk8;
RUN choco install nodejs-lts;
RUN choco install maven;
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

RUN `
    # Download the Build Tools bootstrapper.
    curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe `
    `
    # Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
    && (start /w vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" `
    --add Microsoft.VisualStudio.Workload.AzureBuildTools `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
    --remove Microsoft.VisualStudio.Component.Windows81SDK `
    || IF "%ERRORLEVEL%"=="3010" EXIT 0) `
    `
    # Cleanup
    && del /q vs_buildtools.exe

SHELL ["powershell"]
RUN Invoke-WebRequest "https://aka.ms/vs/16/release/vs_community.exe" -OutFile "$env:TEMP\vs_community.exe" -UseBasicParsing
RUN & "$env:TEMP\vs_community.exe" --add Microsoft.VisualStudio.Workload.NetWeb --includeRecommended --quiet --wait --norestart --noUpdateInstaller | Out-Default

WORKDIR /azp

COPY start.ps1 .

CMD powershell .\start.ps1