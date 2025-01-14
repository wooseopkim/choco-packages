BeforeAll {
    . ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

$sources = (choco source -r | Measure-Object -Line).Lines

Describe 'Get-PackageVersion' {
    Context 'With actual responses' -Skip:($sources -Gt 2) {
        It 'returns empty version with a non-existent package' {
            Get-PackageVersion -Id thispackagedoesnotexist | Should -Be $null
        }

        It 'returns actual version with a released package' {
            Get-PackageVersion -Id firefox | Should -BeGreaterOrEqual ([Version]::new(134, 0, 0))
        }
    }

    Context 'With mocked responses' {
        It 'parses the version <response>' -ForEach @(
            @{ Response = 'answer|42.0'; Expected = [Version]::new(42, 0) }
            @{ Response = 'good|1.6'; Expected = [Version]::new(1, 6) }
            @{ Response = 'package|2.59.16'; Expected = [Version]::new(2, 59, 16) }
            @{ Response = 'something|132.0.6834.83'; Expected = [Version]::new(132, 0, 6834, 83) }
            @{ Response = 'another|1.2.3-rc'; Expected = [Version]::new(1, 2, 3) }
        ) {
            Mock choco { return $response }

            Get-PackageVersion -Id foobar | Should -Be $expected
        }
    }
}
