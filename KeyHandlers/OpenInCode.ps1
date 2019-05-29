Set-PSreadlineKeyHandler -Chord 'Ctrl+x,Ctrl+e' -ScriptBlock {
    $line = $null
    $cursor = $null

    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    $tempFile = New-TemporaryFile
    $tempFile = Rename-Item $tempFile -NewName "$($tempFile.FullName).ps1" -PassThru
    $line | Set-Content -Path $tempFile
    code -n -w $($tempFile.FullName)
    $fileContents = (Get-Content -Raw -Path $tempFile) -replace "\r",""
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
                0,
                $line.Length,
                $fileContents)
    Remove-Item $tempFile -force
}

