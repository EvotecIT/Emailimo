function EmailList {
    param(
        [ScriptBlock]$ListItems,
        [ValidateSet('Unordered', 'Ordered')] [string] $Type = 'Unordered'
    )
    [PSCustomObject] @{
        Type = 'EmailHTML'

}
}