function New-Package {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Source,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Version]$Version,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Checksum,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Uri]$Uri
    )

    $templateName = "$Id.template"

    $packagePath = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $packagePath
    choco pack (Join-Path $Source "$templateName.nuspec") --outputdirectory $packagePath --failonstderr

    Start-Job -ScriptBlock {
        choco install $using:templateName -y --source=$using:packagePath --failonstderr

        choco new --failonstderr $using:Id `
            --template $using:Id `
            --outputdirectory $using:Destination `
            PackageId=$using:Id `
            PackageVersion=$using:Version `
            Checksum=$using:Checksum Uri=$using:Uri
    } | Receive-Job -Wait -AutoRemoveJob
}
