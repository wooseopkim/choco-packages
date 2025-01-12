BeforeAll {
    . ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

Describe 'Get-Document' {
    It 'parses HTML' {
        $doc = Get-Document -Uri ([Uri]::new('https://github.com/'))

        $doc | Should -Not -BeFalse
        $doc.DocumentElement | Should -Not -BeFalse
        $doc.All.Length | Should -BeGreaterOrEqual 32
    }

    Context 'With mocked responses' {
        It 'parses HTML' -ForEach @(
            # https://stackoverflow.com/a/26304776
            @{
                Html   = '<!doctype html><title>a</title>'
                Assert = {
                    param($doc)
                    $doc.DocumentElement.OuterHtml | Should -Be '<html><head><title>a</title></head><body></body></html>'
                }
            }
            @{
                Html   = Get-TestData 'head.html'
                Assert = {
                    param($doc)
                    $doc.QuerySelector('title').TextContent | Should -Be 'Page Title'
                    $doc.QuerySelector('main a').Href | Should -Be 'https://htmlhead.dev/'
                }
            }
        ) {
            Mock Invoke-WebRequest { return @{ Content = $html } }

            $doc = Get-Document -Uri ([Uri]::new('https://example.com'))

            $assert.Invoke($doc)
        }
    }
}
