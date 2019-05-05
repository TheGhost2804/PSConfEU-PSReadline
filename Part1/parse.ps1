$tokens = $null
$err = $null

$parsed = [System.Management.Automation.Language.Parser]::ParseFile("C:\Dev\PSConfEU-PSReadline\Part1\Demo.ps1", [ref]$tokens, [ref]$err)


# Predicate: We want to get any PipeLineASt with more than 2 elements and start and endline numbers are equal.

$predicate = {
    param($ast)
    $ast -is [System.Management.Automation.Language.PipelineAst] -and
    $ast.PipeLineElements.Count -gt 2 -and
    $ast.Extent.StartLineNumber -eq $ast.Extent.EndLineNumber
    
}

$res = $parsed.FindAll($predicate, $true)


