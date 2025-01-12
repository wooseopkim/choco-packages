function ConvertTo-Hashtable {
    [OutputType([Hashtable])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValueType]$Value
    )

    $out = @{}
    $Value.GetType().GetProperties() | ForEach-Object {
        $key = $_.Name
        $out[$key] = $Value.$key
    }
    return $out
}
