function EmailListItem {
    param(
        [string] $Text
    )
    New-HTMLListItem -Text $Text
}