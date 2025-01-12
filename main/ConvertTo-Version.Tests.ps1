BeforeAll {
    . ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

Describe 'ConvertTo-Version' {
    It 'parses <value>' -ForEach @(
        @{ Value = '42'; Expected = [Version]::new(42, 0) }
        @{ Value = '1.2'; Expected = [Version]::new(1, 2) }
        @{ Value = '2025.01.10'; Expected = [Version]::new(2025, 1, 10) }
        @{ Value = '15.09.22-beta'; Expected = [Version]::new(15, 9, 22) }
        @{ Value = '1.2.3.4'; Expected = [Version]::new(1, 2, 3, 4) }
        @{ Value = 'no'; Expected = $null }
        @{ Value = '1..5'; Expected = $null }
    ) {
        ConvertTo-Version -Value $value | Should -Be $expected
    }
}
