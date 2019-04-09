function EmailTo {
    param(
        [string[]] $Addresses
    )

    [PsCustomObject] @{
        Type      = 'HeaderTo'
        Addresses = $Addresses
    }
}