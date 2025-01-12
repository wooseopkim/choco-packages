param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Target
)

$private:dir = Split-Path -Parent $PSCommandPath
. (Join-Path $dir 'Get-PackageVersion.ps1')
. (Join-Path $dir 'ConvertTo-Hashtable.ps1')
. (Join-Path $dir 'New-Package.ps1')
. (Join-Path $dir 'Build-Package.ps1')
. (Join-Path $dir $Target 'Get-UpstreamRelease.ps1')

$uri = [Uri]::new('https://developer.android.com/studio')
$upstreamRelease = Get-UpstreamRelease -Uri $Uri

$packageVersion = Get-PackageVersion -Id $Target

if ($upstreamRelease.Version -Le $packageVersion) {
    return $false
}

$rootDirectory = Split-Path -Parent $PSCommandPath
$template = Join-Path $rootDirectory 'assets' 'templates' $Target
$workspace = Join-Path ([IO.Path]::GetTempPath()) 'workspace'
$output = Join-Path $rootDirectory 'release'

$params = ConvertTo-Hashtable -Value $upstreamRelease
New-Package @params -Id $Target -Source $template -Destination $workspace
Build-Package -Source (Join-Path $workspace $Target) -Destination $output

return $true
