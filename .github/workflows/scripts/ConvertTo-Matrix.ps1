[OutputType([string])]
[CmdletBinding(PositionalBinding = $false)]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [Object[]]$Targets
)

$include = @()
foreach ($target in $Targets) {
    $object = @{}
    foreach ($key in $target.Keys) {
        $jsonKey = $key -Replace '^.', { $_.Value.ToLower() }
        $object.$jsonKey = $target.$key
    }
    $include += $object
}

$matrix = ConvertTo-Json @{ include = $include } -Depth 8 -Compress
return $matrix
