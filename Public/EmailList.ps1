function EmailList {
    [CmdletBinding()]
    param(
        [ScriptBlock]$ListItems,
        [ValidateSet('Unordered', 'Ordered')] [string] $Type = 'Unordered'
    )
    New-HTMLList -Type $Type {
        Invoke-Command -ScriptBlock $ListItems
    }
}