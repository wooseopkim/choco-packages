$private:dir = Split-Path -Parent $PSCommandPath
. (Join-Path $dir 'Get-Document.ps1')
. (Join-Path $dir 'Select-Row.ps1')
. (Join-Path $dir 'New-Release.ps1')

function Get-UpstreamRelease {
    [OutputType([Nullable[Release]])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Uri]$Uri
    )

    $doc = Get-Document -Uri $Uri
    $cells = Select-Row -Document $doc
    $release = New-Release -Data $cells

    return $release
}
