Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+d' -ScriptBlock {
    param (
        [System.ConsoleKeyInfo]$Key,
        [int]$arg
    )
    end {
        $demoData = Get-Content $PSScriptRoot\Demo.json | ConvertFrom-Json
        $windowSize = $host.ui.RawUI.WindowSize.Width

        $selectedDemo = $demoData[$arg]

        [Microsoft.PowerShell.PSConsoleReadLine]::ClearScreen()
        [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()

        foreach ($line in $selectedDemo.Commands) {
            [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
        }

        Write-Host "`n"
        figlet.exe -w $windowSize -c "$($selectedDemo.Header)" | Out-Host
        
        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt(
            $null,
            $Host.Ui.RawUI.CursorPosition.Y + 5
        )
        [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfHistory()


    }
}