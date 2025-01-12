param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string[]]$Commands,
    [Parameter(Mandatory = $false)]
    [switch]$NotCallable
)

$callable = -Not $NotCallable

foreach ($command in $Commands) {
    $path = (Get-Command -Name $command -ErrorAction SilentlyContinue).Path
    $pattern = Join-Path $env:ChocolateyInstall '*'

    $ok = $callable ? ($path -Like $pattern) : ($path -NotLike $pattern)
    if ($ok) {
        continue
    }

    $errorMessage = $callable `
        ? "Expected ``$command`` to be in the path ``$pattern`` but got ``$path``" `
        : "Expected ``$command`` not to be in the path ``$pattern`` but got ``$path``"
    throw $errorMessage
}
