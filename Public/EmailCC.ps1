function EmailCC {
    param(
        [string[]] $Addresses
    )

    [PsCustomObject] @{
        Type      = 'HeaderCC'
        Addresses = $Addresses
    }
}