function EmailListItem {
    [CmdletBinding()]
    param(
        [string] $Text
    )
    New-HTMLListItem -Text $Text
}