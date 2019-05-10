using namespace System.Management.Automation
using namespace System.Management.Automation.Language


$Global:PSReadLineSnippets = Get-Content $PSScriptRoot\Snippets.Json -Raw | ConvertFrom-Json -AsHashtable
# $global:PSReadlineSnippets = @{
#     'selexp' = @{
#         Snippet = @'
# @{
#    Name = "$1"
#    Expression = {}
# }
# '@
#     }
# }

Set-PSReadlineKeyHandler -Key Ctrl+J -Description "Inserts the snippet from the token under or before the cursor" -ScriptBlock {

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    $tokens = $null
    $ast = $null
    $parseErrors = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$parseErrors, [ref]$null)


    foreach ($token in $tokens) {
        $extent = $token.Extent
        if ($extent.StartOffset -le $cursor -and $extent.EndOffset -ge $cursor) {
            $tokenToChange = $token
            break
        }

    }
    if ($tokenToChange -ne $null) {
        $extent = $tokenToChange.Extent
        $tokenText = $extent.Text
        if ($snippet = $global:PSReadlineSnippets.$tokenText) {
            $SnippetText = $Snippet.Snippet
            #Find tab stop, save location and remove it.
            $tabStopIndex = $SnippetText.IndexOf('$1')
            if ($tabStopIndex -ge 0) {
                $SnippetText = $SnippetText.Remove($tabStopIndex,2)
            }

            [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
                $extent.StartOffset,
                $tokenText.Length,
                $SnippetText)

            if ($tabStopIndex -ge 0) {
                [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($extent.StartOffset + $tabStopIndex)
            }
        }
    }
}