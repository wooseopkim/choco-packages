BeforeAll {
    . ($PSCommandPath -Replace '\.Tests\.ps1$', '.ps1')
}

Describe 'Select-Row' {
    It 'selects the proper row' -ForEach @(
        @{
            Html   = '<table><tr><th>OS</th><th>Kind</th></tr><tr><td>windows</td><td>cmd_line_tools</td></tr></table>'
            Assert = {
                param($row)
                $row | Should -Be 'windows', 'cmd_line_tools'
            }
        }
        @{
            Html   = Get-TestData 'table.html'
            Assert = {
                param($row)
                $row | Should -Be 'WINDOWS', 'path/cmd.line.tool.7z'
            }
        }
    ) {
        $context = [AngleSharp.BrowsingContext]::New([AngleSharp.Configuration]::Default)
        $parser = $context.GetService[AngleSharp.Html.Parser.IHtmlParser]()
        $document = $parser.ParseDocument($html)

        $row = Select-Row -Document $document

        $assert.Invoke($row, $null)
    }
}
