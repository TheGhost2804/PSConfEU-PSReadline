using namespace System.Management.Automation
using namespace System.Management.Automation.Language

. $PSScriptRoot\..\Find-Ast.ps1
Set-PSReadlineKeyHandler -Key Ctrl+i -ScriptBlock {
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    $tokens = $null
    $ast = $null
    $parseErrors = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$parseErrors, [ref]$null)

    $nearestAst = Find-Ast -Ast $ast -CursorOffset $cursor
    $commandOrExpression = Find-Ast -Ast $nearestAst -Ancestor -First -FilterScript {
        $_ -is [InvokeMemberExpressionAst] -or
        $_ -is [CommandAst]
    }

    if ($commandOrExpression -is [InvokeMemberExpressionAst]) {
        $cursorPosition = $commandOrExpression.Member.Extent.EndOffset
    }

    if ($commandOrExpression -is [CommandAst]) {
        $cursorPosition = $commandOrExpression.CommandElements[0].Extent.EndOffset
    }

    if ($cursorPosition) {
        $completionMatches = ([System.Management.Automation.CommandCompletion]::CompleteInput(
                $line,
                $cursorPosition, $null
            )).CompletionMatches |
            Select-Object -ExpandProperty ToolTip | Out-String
    }

    if ($completionMatches) {
        $buffer = " `n" + $completionMatches + " `n"
        $bufferHeight = 0

        foreach ($bufferLine in $buffer.Split("`n")) {
            $bufferHeight += [Math]::Ceiling($bufferLine.Length / $host.ui.RawUI.BufferSize.Width)
        }

        $currentCursorPosition = $Host.Ui.RawUI.CursorPosition
        $newYPosition = $currentCursorPosition.Y + $bufferHeight
        $buffer | Out-Host

    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt(
        $null,
        [int]$newYPosition
    )

    }
}