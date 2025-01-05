$ErrorActionPreference = 'Stop'

function Install-AndroidCommandLineTools {
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Url,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Checksum,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Path
  )

  $packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    url           = $Url
    unzipLocation = $Path
    checksum      = $Checksum
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  Install-ChocolateyEnvironmentVariable -variableName 'ANDROID_HOME' -variableValue "$Path" -variableType 'Machine'
}
