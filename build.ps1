param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Target
)

$ErrorActionPreference = 'Stop'

$private:dir = Split-Path -Parent $PSCommandPath

. (Join-Path $dir 'load.ps1')

& (Join-Path $dir 'main' 'Program.ps1') -Target $Target
