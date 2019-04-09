function EmailBody {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position = 0)][ScriptBlock] $EmailBody
    )
    $Email = Invoke-Command -ScriptBlock $EmailBody
    $Email
}