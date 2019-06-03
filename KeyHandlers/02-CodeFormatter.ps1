Set-PSReadLineKeyHandler Ctrl+Alt+f -ScriptBlock {

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)


    $fmt = Invoke-Formatter -ScriptDefinition $line -Settings 'CodeFormattingStroustrup' 
    $fmt = $fmt -replace "\r", ""
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.length, $fmt)
}

