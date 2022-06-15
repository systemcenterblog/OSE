function Get-Partition.fixed {
    [CmdletBinding()]
    param ()

    #=================================================
    #	Return
    #=================================================
    Return (Get-Partition.osd | Where-Object {$_.IsUSB -eq $false})
    #=================================================
}
