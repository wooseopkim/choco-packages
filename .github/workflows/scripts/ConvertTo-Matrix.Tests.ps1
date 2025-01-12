BeforeAll {
    Set-Alias -Name 'Invoke-Script' -Value ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

Describe 'ConvertTo-Matrix' {
    It 'converts into GitHub Workflow matrix' {
        [Hashtable[]]$targets = @(
            @{
                Id       = 'something'
                Commands = @('a', 'b', 'c', 'd')
            }
            @{
                Id       = 'another'
                Commands = @('e', 'f', 'g', 'h')
            }
        )

        $matrix = Invoke-Script -Targets $targets

        $matrix | Should -Be '{"include":[{"commands":["a","b","c","d"],"id":"something"},{"commands":["e","f","g","h"],"id":"another"}]}'
    }
}
