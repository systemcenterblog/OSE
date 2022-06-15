function Get-Disk.fixed {
    [CmdletBinding()]
    param ()
    #=================================================
    #	Get-Disk.osd
    #=================================================
    $GetDisk = Get-Disk.osd -BusTypeNot 'File Backed Virtual',MAX,'Microsoft Reserved',USB,Virtual
    #=================================================
    #	Return
    #=================================================
    Return $GetDisk
    #=================================================
}
