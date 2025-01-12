@{
    Severity            = @('Error', 'Warning')
    IncludeDefaultRules = $true
    Rules               = @{
        PSAvoidUsingPositionalParameters = @{
            CommandAllowList = 'Join-Path'
            Enable           = $true
        }
        PSReviewUnusedParameter          = @{
            CommandsToTraverse = @(
                'Start-Job'
            )
        }
    }
}
