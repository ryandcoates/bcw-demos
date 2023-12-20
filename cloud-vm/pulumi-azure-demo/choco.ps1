# Install
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))


# Install App
choco install microsoft-edge

# List Local apps

choco list --lo

# Install Apps
$Apps = @(
    'nodejs'
    'python'
    'ruby'
    'visualstudiocode'
)