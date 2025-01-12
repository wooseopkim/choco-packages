$private:dir = Split-Path -Parent $PSCommandPath
. (Join-Path (Split-Path -Parent $dir) 'ConvertTo-Version.ps1')

function New-Release {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Release])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Data
    )

    $fileName = ($Data -Match '\.\w+$')[0]
    $checksum = ($Data -Match '^[a-z\d]{16,}$')[0]
    $version = ($fileName | Select-String -AllMatches '(?<version>(\d+\.){0,3}\d+)').Matches | ForEach-Object {
        return $_.Groups['version'].Value
    }

    return [Release]::new(
        (ConvertTo-Version -Value $version),
        [Uri]::new("https://dl.google.com/android/repository/$fileName"),
        $checksum
    )
}
