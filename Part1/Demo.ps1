#Requires -modules PSScriptAnalyzer
function Get-FakeStuff {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    }
    
    process {
        get-ChildItem c:\temp | ? Name -eq "blah"
    }
    
    end {
        Get-ChildItem C:\temp | Where-Object {$_.Name -like 'cov*'} | Foreach-Object {Write-Host $_.Name}
    }
}
 
 