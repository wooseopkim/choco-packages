$ErrorActionPreference = 'Stop'

Invoke-ScriptAnalyzer . -Recurse

$private:dir = Split-Path -Parent $PSCommandPath

. (Join-Path $dir 'load.ps1')

(Get-ChildItem -Path (Join-Path $dir 'test' '*.ps1')) -NotMatch '\.Tests\.ps1$' | ForEach-Object {
    . $_.FullName
}

Invoke-Pester
