# escape=`

# git FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-20211012-windowsservercore-ltsc2019 as baseimage
FROM mcr.microsoft.com/windows/servercore:10.0.20348.2227 as baseimage

SHELL [ "powershell" ]
# ---------------------------------------------
# Chocolatey Package Manager
# ---------------------------------------------
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
ENV chocolateyUseWindowsCompression=false
ENV chocolateyVersion=1.4.0

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco config set cachelocation C:\chococache
RUN choco feature enable --name allowGlobalConfirmation 

# ---------------------------------------------
# Chocolatey Packages
# ---------------------------------------------
RUN choco install curl;
RUN choco install dotnet-7.0-sdk;
RUN dotnet --version;
RUN dotnet tool install --global dotnet-aspnet-codegenerator --version 7.0.0
RUN dotnet new globaljson --sdk-version 7.0.407;
# Set environment variable for .NET 7.0 SDK
ENV DOTNET_PATH="C:\Program Files\dotnet\sdk\7.0.407"
RUN choco install dotnet-6.0-sdk;
#RUN choco install dotnet-5.0-sdk
#RUN choco install dotnet-6.0-aspnetruntime;
#RUN choco upgrade dotnet;
#RUN dotnet tool install --global dotnet-aspnet-codegenerator --version 6.0.0
#RUN dotnet new globaljson --sdk-version 6.0.420;
ENV DOTNET_PATH="C:\Program Files\dotnet\sdk\6.0.420"
RUN dotnet --list-sdks
RUN choco install nuget.commandline;
RUN nuget update -self
RUN nuget sources list
RUN nuget locals all -clear
#RUN choco install git;
#RUN choco install jdk8;
#RUN choco install nodejs-lts;
#RUN choco install maven;
#RUN choco install docker;
#RUN choco install terraform --version 1.7.2 
#RUN choco install terraform-docs;
#RUN choco install openssl;
#RUN choco install wget;
#RUN choco install azure-cli;
#RUN choco install netfx-4.8-devpack -y
#RUN choco install gradle

# Upgrade all Chocolatey packages to their latest versions
RUN choco upgrade all -y



# Download the Visual Studio 2022 bootstrapper.
RUN Invoke-WebRequest "https://aka.ms/vs/17/release/vs_community.exe" -OutFile "$env:TEMP\vs_community.exe" -UseBasicParsing
# Install Visual Studio 2022 with the Microsoft.VisualStudio.Workload.AzureBuildTools workload.
RUN & "$env:TEMP\vs_community.exe" --add Microsoft.VisualStudio.Workload.AzureBuildTools --includeRecommended --quiet --wait --norestart --noUpdateInstaller | Out-Default
RUN Add-WindowsCapability -online -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"

SHELL ["cmd", "/S", "/C"]
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


WORKDIR /azp

COPY start.ps1 .

CMD powershell .\start.ps1
