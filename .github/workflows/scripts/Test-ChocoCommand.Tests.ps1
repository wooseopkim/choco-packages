BeforeAll {
    Set-Alias -Name 'Invoke-Script' -Value ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

Describe 'Test-ChocoCommand' {
    It 'does not throw when <label>' -ForEach @(
        @{
            Label     = 'no commands exist'
            Arguments = @{
                Commands    = @('foo', 'bar', 'baz')
                NotCallable = $true
            }
        }
        @{
            Label     = 'all commands exist'
            Arguments = @{
                Commands    = @('foo', 'bar', 'baz')
                NotCallable = $false
            }
        }
    ) {
        Mock Get-Command {
            $condition = $arguments.NotCallable
            $path = $condition ? 'nowhere' : (Join-Path $env:ChocolateyInstall 'somewhere')
            return @{ Path = $path }
        }

        { & Invoke-Script @arguments } | Should -Not -Throw
    }

    It 'does not throw when <label>' -ForEach @(
        @{
            Label     = 'any command exists'
            Arguments = @{
                Commands    = @('foo', 'bar', 'baz')
                NotCallable = $true
            }
        }
        @{
            Label     = 'any command does not exist'
            Arguments = @{
                Commands    = @('foo', 'bar', 'baz')
                NotCallable = $false
            }
        }
    ) {
        Mock Get-Command {
            $condition = $arguments.NotCallable
            if ($Name -Eq 'baz') {
                $condition = -Not $condition
            }
            $path = $condition ? 'nowhere' : (Join-Path $env:ChocolateyInstall 'somewhere')
            return @{ Path = $path }
        }

        { & Invoke-Script @arguments } | Should -Throw "Expected ````baz```` *"
    }
}
