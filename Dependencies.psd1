@{
    Repositories = @(
        @{
            Name    = 'NuGet'
            Uri     = 'https://api.nuget.org/v3/index.json'
            Trusted = $true
        }
    )
    Resources    = @{
        AngleSharp       = @{
            Version    = '[1.2.0,2)'
            Repository = 'NuGet'
            Library    = '^netstandard\d+(\.\d+)*$'
        }
        PSScriptAnalyzer = @{
            Version    = '[1.23.0,2)'
            Repository = 'PSGallery'
        }
        Pester           = @{
            Version    = '[5.6.1,6)'
            Repository = 'PSGallery'
        }
    }
}
