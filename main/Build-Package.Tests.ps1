BeforeAll {
    . ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

$targets = ($PSCommandPath | Split-Path | Split-Path | Join-Path -ChildPath 'Build.psd1').Targets
Describe 'Build-Package (<id>)' -ForEach $targets {
    It 'builds given choco package' {
        $source = Join-Path (Split-Path -Parent $PSCommandPath) 'assets' 'templates' $id
        $destination = Join-Path $TestDrive 'Build-Package'

        Build-Package -Source $source -Destination $destination

        Get-Item -Path (Join-Path $destination '*.nupkg') | Should -Not -BeFalse
    }
}
