$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path -Parent $PSCommandPath

Get-ChildItem -Path $toolsPath -File -Filter '*.bat' -Recurse | ForEach-Object {
    $name = $_.BaseName
    $path = $_.FullName
    Uninstall-BinFile -Name $name -Path $path
}
