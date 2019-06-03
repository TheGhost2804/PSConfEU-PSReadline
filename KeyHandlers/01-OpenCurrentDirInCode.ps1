Set-PSReadLineKeyHandler -Key Ctrl+Alt+c -BriefDescription "OpenInCodeInsiders" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("code-insiders .")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}