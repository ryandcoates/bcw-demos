function New-ApiProject {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]$Name,

        [Switch]$AddSpec,
        
        [Parameter()]
        [ValidateSet("AzureFuncPS", "AzureFuncCSharp", "AWSLamdaPS")]
        [String]$Stack
    )

    # Creating Project folder
    if (!(Test-Path ./$name)) {
        New-Item $Name -ItemType Directory
    } else {
        throw "Directory already exists, cannot create new project"
    }

    # Dropping .gitignore
    $ignore = New-Item ./$name/.gitignore
    Add-Content -Path $ignore.FullName -Value "**/.vscode"
    
    # Creating default containers
    New-Item ./$name/src -ItemType Directory
    New-Item ./$name/docs -ItemType Directory
    New-Item ./$name/inf -ItemType Directory

    if ($AddSpec) {
        $Spec = New-Item ./$name/docs/openapi.yaml
        Add-Content -PassThru $spec.FullName -Value "openapi: 3.0.0"
    }

    if ($Stack) {
        $loc = Get-Location
        if (Test-Path $name/src) {
            Set-location $name/src
        }
        if ($Stack -eq "AzureFuncPS") {
            if (!(Get-Command func)) {
                throw "Function runtime not available or not in PATH"
            }
                func init --worker-runtime powershell --managed-dependencies
                func new --name HelloWorld --template HttpTrigger 
                set-Location $loc
                New-Item $name/.devcontainer -ItemType Directory
                Copy-Item ./automation/devcontainers/azure-functions/* $name/.devcontainer/

            } elseif ($Stack -eq "AzureFuncCSharp"){
            
            if (!(Get-Command func)) {
                throw "Function runtime not available or not in PATH"
            }
                func init --worker-runtime dotnet
                func new --name HelloWorld --template HttpTrigger 
                set-Location $loc
                New-Item $name/.devcontainer -ItemType Directory
                Copy-Item ./automation/devcontainers/azure-functions/* $name/.devcontainer/ 

            } elseif ($Stack -eq "AWSLamdaPS"){
                throw "Not Implemented"
            }
    }
}
