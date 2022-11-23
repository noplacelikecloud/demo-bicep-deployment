function Read-TableStorage {
    param (
        [String]$StorageAccountName,
        [String]$TableName,
        [String]$StorageAccountRG,
        [String]$PartitionKey,
        [String]$RowKey
    )
    
    try {

        $sa = Get-AzStorageAccount -ResourceGroupName $StorageAccountRG -Name $StorageAccountName
        $cloudTable = (Get-AzStorageTable -Name $TableName -Context $sa.Context).CloudTable

        $tabledata = Get-AzTableRow -Table $cloudTable -PartitionKey $PartitionKey -RowKey $RowKey

        $tabledata.PSObject.Properties.Remove("PartitionKey")
        $tabledata.PSObject.Properties.Remove("RowKey")
        $tabledata.PSObject.Properties.Remove("TableTimestamp")
        $tabledata.PSObject.Properties.Remove("Etag")
        
    } catch {
        Write-Error "ERROR: Cannot read $StorageAccountName/$TableName ! The reason is: $_"
        exit 0
    }

    $output = @{}
    $tabledata.psobject.properties | ForEach-Object { $output[$_.Name] = $_.Value }

    return $output

}

function Write-TableStorageValue {
    param (
        [String]$StorageAccountName,
        [String]$TableName,
        [String]$StorageAccountRG,
        [String]$PartitionKey,
        [String]$RowKey,
        [String]$Property,
        [String]$Value
    )

    $sa = Get-AzStorageAccount -ResourceGroupName $StorageAccountRG -Name $StorageAccountName
    $cloudTable = (Get-AzStorageTable -Name $TableName -Context $sa.Context).CloudTable

    $tableData = Get-AzTableRow -Table $cloudTable -PartitionKey $PartitionKey -RowKey $RowKey

    if ([bool]($tableData.PSobject.Properties.name -contains $Property)) {
        $tableData.$Property = $Value
    }
    else {
        Add-Member -InputObject $tableData -MemberType NoteProperty -Name $Property -Value $Value
    }

    Update-AzTableRow -Table $cloudTable -entity $tableData

}

Export-ModuleMember -Function Read-TableStorage,Write-TableStorageValue