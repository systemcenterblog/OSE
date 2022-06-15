function Get-Partition.usb {
    [CmdletBinding()]
    param ()

    #=================================================
    #	Return
    #=================================================
    Return (Get-Partition.osd | Where-Object {$_.IsUSB -eq $true})
    #=================================================
}
