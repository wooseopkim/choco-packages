BeforeAll {
    . ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

Describe 'Get-TestData' {
    It 'reads test data' {
        Get-TestData 'studio.html' | Should -Not -BeFalse
    }
}