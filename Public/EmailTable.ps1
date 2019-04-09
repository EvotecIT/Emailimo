function EmailTable {
    param(
        $Table
    )


    [PSCustomObject] @{
        Type = 'EmailTable'
        Data = [ordered] @{
            DataTable = $Table
        }
    }
}