$private:dir = Split-Path -Parent $PSCommandPath
. (Join-Path $dir 'ConvertTo-Version.ps1')

function Get-PackageVersion {
    [OutputType([Version])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Id
    )

    $output = choco search -exact $Id --limitoutput
    if (-Not $output) {
        return $null
    }
    $version = ($output -Split '\|')[1]
    ConvertTo-Version -Value $version
}
