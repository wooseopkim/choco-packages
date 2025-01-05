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

    Get-ChildItem -Path "$Path" -File -Filter '*.bat' -Recurse | ForEach-Object {
        $name = "$($_.BaseName)"
        $path = "$($_.FullName)"
        Install-BinFile -Name "$name" -Path "$path"
    }

    Install-ChocolateyEnvironmentVariable -variableName 'ANDROID_HOME' -variableValue "$Path" -variableType 'Machine'
}

function Uninstall-AndroidCommandLineTools {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    Get-ChildItem -Path "$Path" -File -Filter '*.bat' -Recurse | ForEach-Object {
        $name = "$($_.BaseName)"
        $path = "$($_.FullName)"
        Uninstall-BinFile -Name "$name" -Path "$path"
    }
}
