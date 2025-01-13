function Compare-Value {
    param (
        [Parameter(Mandatory)]
        [AllowNull()]
        [Object]$Actual,
        [Parameter(Mandatory)]
        [AllowNull()]
        [Object]$Expected
    )

    $type = ($Actual)?.GetType()
    $type | Should -Be (($Expected)?.GetType())
    if ([Hashtable].IsAssignableFrom($type)) {
        $Actual.Keys | Should -HaveCount $Expected.Keys.Count
        foreach ($key in $Actual.Keys) {
            Compare-Value $Actual.$key $Expected.$key
        }
        continue
    }
    if ([Array].IsAssignableFrom($type)) {
        $Actual | Should -HaveCount $Expected.Count
        for (($i = 0); $i -Lt $Actual.Count; $i++) {
            Compare-Value $Actual[$i] $Expected[$i]
        }
        continue
    }
    $Actual | Should -BeExactly $Expected
}
