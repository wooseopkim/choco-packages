function ConvertTo-Version {
    [OutputType([Version])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Value
    )

    $int = $null
    if ([Int32]::TryParse($Value, [Globalization.NumberStyles]::Integer, $null, [ref]$int)) {
        return [Version]::new($int, 0)
    }

    $sanitized = $Value -Replace '-[^-]+$', ''
    $version = $null
    if ([Version]::TryParse($sanitized, [ref]$version)) {
        return $version
    }
    return $null
}
