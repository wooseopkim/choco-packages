BeforeAll {
    . ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

Describe 'New-Release' {
    It 'builds a Release from [<data>]' -ForEach @(
        @{
            Data     = @(
                'Windows'
                'commandlinetools-win-11076708_latest.zip'
                '153.6 MB'
                '4d6931209eebb1bfb7c7e8b240a6a3cb3ab24479ea294f3539429574b1eec862'
            )
            Expected = @(
                [Version]::new('11076708.0'),
                [Uri]::new('https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip'),
                '4d6931209eebb1bfb7c7e8b240a6a3cb3ab24479ea294f3539429574b1eec862'
            )
        }
        @{
            Data     = @(
                'Linux'
                'commandlinetools-linux-11076708_latest.zip'
                '153.6 MB'
                '2d2d50857e4eb553af5a6dc3ad507a17adf43d115264b1afc116f95c92e5e258'
            )
            Expected = @(
                [Version]::new('11076708.0'),
                [Uri]::new('https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip'),
                '2d2d50857e4eb553af5a6dc3ad507a17adf43d115264b1afc116f95c92e5e258'
            )
        }
        @{
            Data     = @(
                'release-1.2.3.zip'
                '0800fc577294c34e0b28ad2839435945'
            )
            Expected = @(
                [Version]::new('1.2.3'),
                [Uri]::new('https://dl.google.com/android/repository/release-1.2.3.zip'),
                '0800fc577294c34e0b28ad2839435945'
            )
        }
        @{
            Data     = @(
                'dist/program_1.6_download.exe'
                '8e835240f89a32be8c1c2f31fba878967b8d617d906e128d76f7f333237d63a598cb42bef9b79c6375909e5f2ad5a040c905a8673b915ec65c3ad654505a39a4'
            )
            Expected = @(
                [Version]::new('1.6'),
                [Uri]::new('https://dl.google.com/android/repository/dist/program_1.6_download.exe'),
                '8e835240f89a32be8c1c2f31fba878967b8d617d906e128d76f7f333237d63a598cb42bef9b79c6375909e5f2ad5a040c905a8673b915ec65c3ad654505a39a4'
            )
        }
    ) {
        New-Release -Data $data | Should -Be ([Release]::new.Invoke($expected))
    }
}
