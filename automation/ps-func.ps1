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

    # Variables for File Scaffolds
    $ProjectName = $Name

    #Folder List
    $Folders = @(
        'docs'
        'inf'
        'src'
        'docs/arch'
        'docs/adrs'
        'docs/specification'
    )

    # Creating Project folder
    Write-Verbose "[ Creating Project Folder ]"
    if (!(Test-Path ./$name)) {
        New-Item $Name -ItemType Directory
    }
    else {
        throw "Directory already exists, cannot create new project"
    }

    # Dropping .gitignore
    $ignore = New-Item ./$name/.gitignore
    Add-Content -Path $ignore.FullName -Value "**/.vscode"

    # Dropping Readme

    $readme = New-Item ./$name/README.md
    $readmeUri = "https://raw.githubusercontent.com/ryandcoates/bcw-demos/master/automation/readme.template.txt"
    $readMeContent = (Invoke-WebRequest -Uri "$readmeUri").Content
    Set-Content $readme.FullName -Value $readMeContent
    
    # Creating default folders
    Write-Verbose "[ Creating folder Structure ]"
    ForEach ($folder in $Folders) {
        $FolderName = Join-Path $name -ChildPath $folder
        New-Item -Type Directory -Name ./$FolderName
    }

    if ($AddSpec) {
        Write-Verbose "[ AddSpec: $AddSpec - Generating Empty Open API Specification File"
        $Spec = New-Item ./$name/docs/specification/$name.v1.yml
        Add-Content -PassThru $spec.FullName -Value "openapi: 3.1.0"
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

        }
        elseif ($Stack -eq "AzureFuncCSharp") {
            Write-Verbose "[ Attempting to Scaffold Azure C# Function ]"
            if (!(Get-Command func)) {
                throw "Function runtime not available or not in PATH"
            }
            func init --worker-runtime dotnet --name functionApp
            func new --name HelloWorld --template HttpTrigger 
            $csProj = Get-Item "src.csproj"
            set-Location $loc
            New-Item $name/.devcontainer -ItemType Directory
            Write-Verbose "[ Adding Azure Function .devcontainer ]"
            $dcDockerUri = "https://raw.githubusercontent.com/ryandcoates/bcw-demos/master/automation/devcontainers/azure-functions/Dockerfile"
            $dcJsonUri = "https://raw.githubusercontent.com/ryandcoates/bcw-demos/master/automation/devcontainers/azure-functions/devcontainer.json"
            Invoke-WebRequest -Uri "$dcJsonUri" -OutFile $name/.devcontainer/devcontainer.json
            Invoke-WebRequest -Uri "$dcDockerUri" -OutFile $name/.devcontainer/Dockerfile
            
            Write-Verbose "[ Running Dotnet Restore ]"
            dotnet restore $csProj.FullName
        }
        elseif ($Stack -eq "AWSLamdaPS") {
            throw "Not Implemented"
        }
    }
}
