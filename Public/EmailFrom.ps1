function EmailFrom {
    param(
        [string] $Address
    )

    [PsCustomObject] @{
        Type      = 'HeaderFrom'
        Address = $Address
    }
}