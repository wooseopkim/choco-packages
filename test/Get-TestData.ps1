function Get-TestData {
    [OutputType([AngleSharp.Dom.Document])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$AdditionalPath
    )

    $basePath = Join-Path (Split-Path -Parent $PSCommandPath) 'assets' 'testdata'
    $testDataPath = Join-Path -Path $basePath -ChildPath $Path -AdditionalChildPath $AdditionalPath
    $testData = Get-Content -Raw -Path $testDataPath
    return $testData
}
