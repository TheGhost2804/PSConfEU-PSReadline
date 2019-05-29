Set-PSReadLineKeyHandler -Key Alt+m -ScriptBlock {
    if (-not $global:PSReadlineMacros) {
        $global:PSReadlineMacros = @{}
    }

    $key = [console]::ReadKey($true)

    $cursor = $null
    $line = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,[ref]$cursor)

    $global:PSReadlineMacros[$key.KeyChar] = $line
}

Set-PSReadLineKeyHandler -Key Alt+M {
    $Key = [console]::ReadKey($true)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Global:PSReadlineMacros[$Key.KeyChar])

}