function Build-Package {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Source,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination
    )

    $nuspec = Get-Item (Join-Path $Source '*.nuspec')
    choco pack $nuspec.FullName --outputdirectory $Destination
}
