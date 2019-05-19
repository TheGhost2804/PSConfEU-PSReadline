Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+d' -ScriptBlock {
    param (
        [System.ConsoleKeyInfo]$Key,
        [int]$arg
    )
    end {
        $demoData = Get-Content $PSScriptRoot\Demo.json | ConvertFrom-Json
        $windowSize = $host.ui.RawUI.WindowSize.Width

        $global:selectedDemo = $demoData[$arg]
        $global:selectedCommand = 0

        [Microsoft.PowerShell.PSConsoleReadLine]::ClearScreen()
        [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()


        # foreach ($line in $selectedDemo.Commands) {
        #     [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
        # }

        Write-Host "`n"
        figlet.exe -w $windowSize -c "$($selectedDemo.Header)" | Out-Host

        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt(
            $null,
            $Host.Ui.RawUI.CursorPosition.Y + 5
        )
        # [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfHistory()
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0,0,$selectedDemo.Commands[0])

    }
}

Set-PSReadLineKeyHandler -Key Ctrl+n -ScriptBlock {
    $global:selectedCommand++
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0,0,$global:selectedDemo.Commands[$global:selectedCommand])
}
Set-PSReadLineKeyHandler -Key Ctrl+p -ScriptBlock {
    $global:selectedCommand--
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0,0,$global:selectedDemo.Commands[$global:selectedCommand])
}