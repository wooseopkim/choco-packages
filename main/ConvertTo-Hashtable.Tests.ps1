BeforeAll {
    . ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

Describe 'ConvertTo-Hashtable' {
    It 'converts <value>' -ForEach @(
        @{
            Value    = [Range]::new(2019, 2022)
            Expected = @{ Start = [Index]::new(2019); End = [Index]::new(2022); All = $null }
        }
        @{
            Value    = [Index]::new(42, $true)
            Expected = @{ Value = 42; IsFromEnd = $true; Start = $null; End = $null }
        }
    ) {
        $actual = ConvertTo-Hashtable -Value $value

        $actual.Keys | Should -HaveCount $expected.Keys.Count
        foreach ($key in $actual.Keys) {
            $actual.$key | Should -Be $expected.$key
        }
    }
}
