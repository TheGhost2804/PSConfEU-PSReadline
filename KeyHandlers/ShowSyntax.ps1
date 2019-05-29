using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Set-PSReadlineKeyHandler -Key Ctrl+i -ScriptBlock {
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
            $currentToken = $token
            break
        }
    }

    if ($currentToken.TokenFlags -band [TokenFlags]::CommandName) {
        $cmdDefinition = Get-Command $currentToken.Text

        $commandSyntax = switch ($cmdDefinition.CommandType) {
            Alias {  Get-Command $cmdDefinition.ResolvedCommand -Syntax }
            Function { Get-Command $cmdDefinition -Syntax }
            Cmdlet { Get-Command $cmdDefinition -Syntax }
            Default {}
        }
    }

    if ($commandSyntax) {

        $buffer = " `n" + $commandSyntax + " `n"

        $bufferHeight = 0

        foreach($bufferLine in $buffer.Split("`n")) {
            $bufferHeight += [Math]::Ceiling($bufferLine.Length / $host.ui.RawUI.BufferSize.Width)
        }

        $currentCursorPosition =$Host.Ui.RawUI.CursorPosition
        $newYPosition = $currentCursorPosition.Y + $bufferHeight
        $buffer | Out-Host

        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt(
            $null,
            [int]$newYPosition
        )

    }
}