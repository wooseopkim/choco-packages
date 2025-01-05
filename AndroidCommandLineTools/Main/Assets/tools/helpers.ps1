$ErrorActionPreference = 'Stop'

function Install-AndroidCommandLineTools {
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Url,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Checksum
  )

  $toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

  $packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    url           = $Url
    unzipLocation = $toolsDir
    checksum      = $Checksum
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  Install-ChocolateyEnvironmentVariable -variableName "ANDROID_HOME" -variableValue "$toolsDir" -variableType = 'Machine'
}
