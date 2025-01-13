BeforeAll {
    Set-Alias -Name 'Invoke-Script' -Value ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

Describe 'ConvertTo-Matrix' {
    It 'converts into a GitHub Workflow matrix' {
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

        $actual = ConvertFrom-Json -AsHashtable -InputObject $matrix
        $expected = ConvertFrom-Json -AsHashtable -InputObject '{"include":[{"id":"something","commands":["a","b","c","d"]},{"id":"another","commands":["e","f","g","h"]}]}'
        Compare-Value -Actual $actual -Expected $expected
    }
}
