BeforeAll {
    $dir = Split-Path -Parent $PSCommandPath
    . (Join-Path $dir 'Get-PackageVersion.ps1')
    . (Join-Path $dir 'New-Package.ps1')
    . (Join-Path $dir 'Build-Package.ps1')

    Set-Alias -Name 'Invoke-Script' -Value ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

$targets = ($PSCommandPath | Split-Path | Split-Path | Join-Path -ChildPath 'Build.psd1').Targets
Describe 'Program (<id>)' -ForEach $targets {
    BeforeAll {
        . (Join-Path $dir $id 'Get-UpstreamRelease.ps1')

        Mock Get-UpstreamRelease {
            $version = [Version]::new(1, 2, 3)
            $uri = [Uri]::new('https://example.com')
            $checksum = 'checksumchecksumchecksumchecksum'
            return [Release]::new($version, $uri, $checksum)
        }

        Mock New-Package {}

        Mock Build-Package {}
    }

    Context 'When package has not been released yet' {
        BeforeAll {
            Mock Get-PackageVersion { return $null }
        }

        It 'builds the package' {
            Invoke-Script -Target $id | Should -Be $true
            Should -Invoke New-Package
            Should -Invoke Build-Package
        }
    }

    Context 'When package is up-to-date' {
        BeforeAll {
            Mock Get-PackageVersion { return [Version]::new(1, 2, 3) }
        }

        It 'skips the build' {
            Invoke-Script -Target $id | Should -Be $false
            Should -Not -Invoke New-Package
            Should -Not -Invoke Build-Package
        }
    }

    Context "When there's a new upstream release" {
        BeforeAll {
            Mock Get-PackageVersion { return [Version]::new(1, 2) }
        }

        It 'builds the package' {
            Invoke-Script -Target $id | Should -Be $true
            Should -Invoke New-Package
            Should -Invoke Build-Package
        }
    }
}
