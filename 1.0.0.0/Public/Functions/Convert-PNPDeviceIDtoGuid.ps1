function Convert-PNPDeviceIDtoGuid {
    [CmdLetBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$PNPDeviceID
    )

    #$GuidPattern = '{[-0-9A-F]+?}'
    #($DeviceID | Select-String -Pattern $GuidPattern -AllMatches | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value)

    $GuidPattern = '\{?(([0-9a-f]){8}-([0-9a-f]){4}-([0-9a-f]){4}-([0-9a-f]){4}-([0-9a-f]){12})\}?'
    ($PNPDeviceID | Select-String -Pattern $GuidPattern -AllMatches | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value)
}
