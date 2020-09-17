FROM mcr.microsoft.com/dotnet/core/sdk:3.1

# ENV FUNCTIONS_WORKER_RUNTIME=powershell
# ENV FUNCTIONS_WORKER_RUNTIME_VERSION=~7

# Download the PowerShell package and save it
ARG PS_VERSION=7.0.3
ARG PS_PACKAGE=powershell_${PS_VERSION}-1.debian.10_amd64.deb
ARG PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE}
ADD ${PS_PACKAGE_URL} /tmp/powershell.deb

# Define ENVs for Localization/Globalization
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    # set a fixed location for the Module analysis cache
    PSModuleAnalysisCachePath=/var/cache/microsoft/powershell/PSModuleAnalysisCache/ModuleAnalysisCache

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get purge -y imagemagick imagemagick-6-common \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git and needed tools are installed
    && apt-get -y install \
    git \
    python3 \
    openssh-client \
    less \
    unzip \
    iproute2 \
    procps \
    curl \
    apt-transport-https \
    locales \
    ca-certificates \
    gss-ntlmssp \
    gnupg2 \
    lsb-release \
    && apt-get dist-upgrade -y \
    # enable en_US.UTF-8 locale
    && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    # generate locale
    && locale-gen && update-locale \
    && apt install -y /tmp/powershell.deb \
    # remove PowerShell package
    && rm /tmp/powershell.deb \
    # install Az module
    && pwsh \
        -NoLogo \
        -NoProfile \
        -Command " \
        \$ProgressPreference = 'SilentlyContinue'; \
        Set-PSRepository PSGallery -InstallationPolicy Trusted; \
        Install-Module -Name Az -AllowClobber -Scope AllUsers -Confirm:\$False -Force; \
        \$ProgressPreference = 'Continue' "\
    # install Pester
    && pwsh \
        -NoLogo \
        -NoProfile \
        -Command " \
        \$ProgressPreference = 'SilentlyContinue'; \
        Set-PSRepository PSGallery -InstallationPolicy Trusted; \
        Install-Module -Name Pester -AllowClobber -Scope AllUsers -Confirm:\$False -Force; \
        \$ProgressPreference = 'Continue' "\
    # initialize PowerShell module cache
    # invoke a nonexistent command to force PowerShell to perform complete module analysis
    && pwsh -NoLogo -NoProfile -Command "try { IAmSureThisCommandDoesNotExist } catch { exit 0 }" \
    && pwsh \
        -NoLogo \
        -NoProfile \
        -Command " \
        \$ErrorActionPreference = 'Stop' ; \
        \$ProgressPreference = 'SilentlyContinue' ; \
        while(!(Test-Path -Path \$env:PSModuleAnalysisCachePath)) {  \
            Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; \
            Start-Sleep -Seconds 6 ; \
        }" \
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Install Azure Functions Core Tools v3 and Azure CLI
    && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
    && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
    && wget -q https://packages.microsoft.com/config/debian/9/prod.list \
    && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
    && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
    && chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get -y install azure-cli azure-functions-core-tools-3 \
    && apt-get -y install npm \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g @stoplight/spectral @stoplight/prism-cli

# Uncomment to opt out of Func CLI telemetry gathering
#ENV FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=true