function EmailTable {
    [CmdletBinding()]
    param(
        $Table
    )
    New-HTMLTable -DataTable $Table
}