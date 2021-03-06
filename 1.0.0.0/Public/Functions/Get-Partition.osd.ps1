function Get-Partition.osd {
    [CmdletBinding()]
    param ()
    #=================================================
    #	PSBoundParameters
    #=================================================
    $IsConfirmPresent   = $PSBoundParameters.ContainsKey('Confirm')
    $IsForcePresent     = $PSBoundParameters.ContainsKey('Force')
    $IsVerbosePresent   = $PSBoundParameters.ContainsKey('Verbose')
    #=================================================
    #	Get Variables
    #=================================================
    $GetDisk = Get-Disk.osd -BusType USB
    $GetPartition = Get-Partition | Sort-Object DiskNumber, PartitionNumber
    #=================================================
    #	Add Property IsUSB
    #=================================================
    foreach ($Partition in $GetPartition) {
        if ($Partition.DiskNumber -in $($GetDisk).DiskNumber) {
            $Partition | Add-Member -NotePropertyName 'IsUSB' -NotePropertyValue $true -Force
        } else {
            $Partition | Add-Member -NotePropertyName 'IsUSB' -NotePropertyValue $false -Force
        }
    }
    #=================================================
    #	Return
    #=================================================
    Return $GetPartition
    #=================================================
}
