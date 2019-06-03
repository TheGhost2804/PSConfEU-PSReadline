Set-PSReadLineKeyHandler -Key Alt+m -ScriptBlock {
    if (-not $global:PSReadlineMacros) {
        $global:PSReadlineMacros = @{}
    }

    $key = [console]::ReadKey($true)

    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart,[ref]$selectionLength)

    $cursor = $null
    $line = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,[ref]$cursor)

    if ($selectionStart -ge 0) {
        $line = $line.SubString($selectionStart, $selectionLength)
    }

    $global:PSReadlineMacros[$key.KeyChar] = $line
}

Set-PSReadLineKeyHandler -Key Alt+M {
    $Key = [console]::ReadKey($true)
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Global:PSReadlineMacros[$Key.KeyChar])

}