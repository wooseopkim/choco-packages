$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path -Parent $PSCommandPath

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    url           = '[[Uri]]'
    unzipLocation = $toolsPath
    checksum      = '[[Checksum]]'
    checksumType  = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs

Get-ChildItem -Path $toolsPath -File -Filter '*.bat' -Recurse | ForEach-Object {
    $name = $_.BaseName
    $path = $_.FullName
    Install-BinFile -Name $name -Path $path
}

Install-ChocolateyEnvironmentVariable -variableName 'ANDROID_HOME' -variableValue $toolsPath

