function EmailBCC {
    param(
        [string[]] $Addresses
    )

    [PsCustomObject] @{
        Type      = 'HeaderBCC'
        Addresses = $Addresses
    }
}