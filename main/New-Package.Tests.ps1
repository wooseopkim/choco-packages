BeforeAll {
    . ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

$targets = ($PSCommandPath | Split-Path | Split-Path | Join-Path -ChildPath 'Build.psd1').Targets
Describe 'New-Package (<id>)' -ForEach $targets {
    It 'creates a package definition' {
        $params = @{
            Id          = $target
            Source      = Join-Path (Split-Path -Parent $PSCommandPath) 'assets' 'templates' $target
            Destination = Join-Path $TestDrive 'New-Package'
            Version     = [Version]::new(1, 28, 34)
            Uri         = [Uri]::new('https://example.com')
            Checksum    = 'checksumchecksumchecksumchecksumchecksum'
        }
        $chocolateyInstall = $env:ChocolateyInstall

        New-Package @params

        $nuspec = Get-Content -Raw -Path (Join-Path $params.Destination $params.Id "$($params.Id).nuspec")
        ([System.Xml.XmlDocument]$nuspec).package.metadata.version | Should -Be '1.28.34'
        $env:ChocolateyInstall | Should -Be $chocolateyInstall
    }
}
