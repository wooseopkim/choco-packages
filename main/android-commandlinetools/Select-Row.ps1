function Select-Row {
    [OutputType([string[]])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [AngleSharp.Dom.Document]$Document
    )

    $allRows = $Document.QuerySelectorAll('tr:not(:has(th))')

    $commandLineToolsRows = $allRows | Where-Object {
        $_.TextContent -Match 'c(om)?m(an)?d[^a-z]*line[^a-z]*tools?'
    } | Select-Object { $_.QuerySelectorAll('td').TextContent.Trim() }

    foreach ($row in $commandLineToolsRows) {
        $value = $row.PSObject.Properties.value
        if (-Not ($value -Match 'windows')) {
            continue
        }
        return $value
    }
    return @()
}
