<#
.SYNOPSIS
Checks if more than two pipeline elements are on the same line

.DESCRIPTION
Checks if more than two pipeline elements are on the same line

.PARAMETER ScriptBlockAst
Parameter description

.EXAMPLE
An example

.NOTES
General notes

.INPUTS
    [System.Management.Automation.Language.ScriptBlockAst]
.OUTPUTS
    [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
#>

function Measure-MultiplePipesOnSingleLine {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]
        $ScriptBlockAst
    )

    
    process {

        $results = @()
        $predicate = {
            param($ast)
            $ast -is [System.Management.Automation.Language.PipelineAst] -and
            $ast.PipeLineElements.Count -gt 2 -and
            $ast.Extent.StartLineNumber -eq $ast.Extent.EndLineNumber
        }

         [System.Management.Automation.Language.Ast[]]$astResult = $ScriptBlockAst.FindAll(
            $predicate, $true
         )

        foreach ($res in $AstResult) {
            $results += [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                'Message' = "Pipeline is more than two elements long and on single line"
                'Extent' = $res.Extent
                'RuleName' = $PSCmdlet.MyInvocation.InvocationName
                'Severity' = 'Information'
            }
        }

        $results
    }
}

Export-ModuleMember -Function Measure-MultiplePipesOnSingleLine