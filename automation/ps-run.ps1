Get-Process

Get-ChildItem

Get-Command | Measure-Object

$WOWAPIURI = "https://owen-wilson-wow-api.onrender.com/wows/random"

(Invoke-WebRequest -URi $WOWAPIURI).Content
((Invoke-WebRequest -URi $WOWAPIURI).Content | ConvertFrom-Json)
((Invoke-WebRequest -URi $WOWAPIURI).Content | ConvertFrom-Json).full_line


$apps = @(
    'brave'
)

forEach ($app in $apps) {
    choco install $app -y
}