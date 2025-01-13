BeforeAll {
    . ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

Describe 'Compare-Value' {
    It 'passes with equal values (<actual>, <expected>)' -ForEach @(
        @{ Actual = @{}; Expected = @{} }
        @{ Actual = $null; Expected = $null }
        @{ Actual = $true; Expected = $true }
        @{ Actual = 42; Expected = 42 }
        @{ Actual = @(1, 2, 3); Expected = @(1, 2, 3) }
        @{ Actual = "wow"; Expected = "wow" }
        @{
            Actual   = @{ Foo = @(9, 99, 999); Bar = @{ X = @('string', 1); Y = @{ Value = -456 } } }
            Expected = @{ Foo = @(9, 99, 999); Bar = @{ X = @('string', 1); Y = @{ Value = -456 } } }
        }
        @{
            Actual   = @(@{}, @(@{One = 1; Two = "two" }))
            Expected = @(@{}, @(@{One = 1; Two = "two" }))
        }
    ) {
        Compare-Value -Actual $actual -Expected $expected
    }

    It 'throws with different values (<actual>, <expected>)' -ForEach @(
        @{ Actual = @{}; Expected = @() }
        @{ Actual = @{ Value = 42 }; Expected = @{} }
        @{ Actual = $null; Expected = $false }
        @{ Actual = $true; Expected = 1 }
        @{ Actual = @(1, 2, 3); Expected = @(1, 2, 3, 4) }
        @{ Actual = "wow"; Expected = "no wow" }
        @{
            Actual   = @{ Foo = @(9, 99, 999); Bar = @{ X = @('string', 1); Y = @{ Value = -456 } } }
            Expected = @{ Foo = @(9, 99, 999); Bar = @{ X = @('string', '1'); Y = @{ Value = -456 } } }
        }
        @{
            Actual   = @(@{}, @(@{One = 1; Two = "two"; Three = $false }))
            Expected = @(@{}, @(@{One = 1; Two = "two" }))
        }
    ) {
        { Compare-Value -Actual $actual -Expected $expected } | Should -Throw
    }
}
