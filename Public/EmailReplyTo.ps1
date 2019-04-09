function EmailCC {
    param(
        [string] $Address
    )

    [PsCustomObject] @{
        Type    = 'HeaderReplyTo'
        Address = $Address
    }
}