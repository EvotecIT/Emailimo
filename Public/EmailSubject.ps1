function EmailSubject {
    param(
        [string] $Subject
    )

    [PsCustomObject] @{
        Type    = 'HeaderSubject'
        Subject = $Subject
    }
}