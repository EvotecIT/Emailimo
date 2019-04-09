function EmailAttachment {
    param(
        [string[]] $FilePath
    )
    [PSCustomObject] @{
        Type     = 'HeaderAttachment'
        FilePath = $FilePath
    }
}