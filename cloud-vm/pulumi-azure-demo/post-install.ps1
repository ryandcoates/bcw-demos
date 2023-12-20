Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$apps = @(
    "vscode",
    "firefox",
    "vlc",
    "nodejs-lts",
    "dotnet"
)

forEach ($app in $apps) {
    choco install $app -y
}