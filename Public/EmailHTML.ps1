function EmailHTML {
    param(
        [ScriptBlock] $HTML
    )
    [PSCustomObject] @{
        Type = 'EmailHTML'
        HTML = Invoke-Command -ScriptBlock $HTML
    }
}