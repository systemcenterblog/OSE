function Get-ReAgentXml {
    <#
    .SYNOPSIS
    Returns information from the Reagent XML file

    .DESCRIPTION
    Returns information from the Reagent XML file
    This function must be run in Windows

    .LINK
    https://github.com/OSDeploy/OSD/tree/master/Docs
    #>
    [CmdletBinding()]
    param ()
    #=================================================
    #	Block
    #=================================================
    Block-WinPE
    Block-StandardUser
    Block-WindowsVersionNe10
    Block-PowerShellVersionLt5
    #=================================================
    #	ReAgent.xml
    #=================================================
    if (-NOT (Test-Path "$env:SystemRoot\System32\Recovery\ReAgent.xml")) {
        Write-Warning "Unable to find $env:SystemRoot\System32\Recovery\ReAgent.xml"
    }
    else {
        [xml]$XmlDocument = Get-content -Path "$env:SystemRoot\System32\Recovery\ReAgent.xml" -Raw

        $XmlDocument.SelectNodes('WindowsRE') | ForEach-Object {

            
            $WinreLocationGuid = $_.WinreLocation.guid
            $WinreLocationId = $_.WinreLocation.id
            $WinreLocationOffset = $_.WinreLocation.offset
            $WinreLocationPath = $_.WinreLocation.path

            if ($WinreLocationId -gt 1000) {
                $WinreLocationPartition = (Get-Disk | Where-Object {$_.Signature -eq $WinreLocationId} | Get-Partition | Where-Object {$_.Offset -eq $WinreLocationOffset}).PartitionNumber
            }
            else {
                $WinreLocationPartition = (Get-Disk -Number $WinreLocationId | Get-Partition | Where-Object {$_.Offset -eq $WinreLocationOffset}).PartitionNumber
            }


            $WinreBCD = $_.WinreBCD.id -replace ('{','') -replace ('}','')

            $ReAgentInfo = [PSCustomObject]@{
                CustomImageAvailable = $_.CustomImageAvailable.state
                DownlevelWinreLocationGuid = $_.DownlevelWinreLocation.guid
                DownlevelWinreLocationId = $_.DownlevelWinreLocation.id
                DownlevelWinreLocationOffset = $_.DownlevelWinreLocation.offset
                DownlevelWinreLocationPath = $_.DownlevelWinreLocation.path
                ImageLocationGuid = $_.ImageLocation.guid
                ImageLocationId = $_.ImageLocation.id
                ImageLocationOffset = $_.ImageLocation.offset
                ImageLocationPath = $_.ImageLocation.path
                InstallState = $_.InstallState.state
                IsAutoRepairOn = $_.IsAutoRepairOn.state
                IsServer = $_.IsServer.state
                IsWimBoot = $_.IsWimBoot.state
                NarratorScheduled = $_.NarratorScheduled.state
                OemTool = $_.OemTool.state
                OperationParam = $_.OperationParam.path
                OperationPermanent = $_.OperationPermanent.state
                OsBuildVersion = $_.OsBuildVersion.path
                OsInstallAvailable = $_.OsInstallAvailable.state
                PBRCustomImageLocationGuid = $_.PBRCustomImageLocation.guid
                PBRCustomImageLocationId = $_.PBRCustomImageLocation.id
                PBRCustomImageLocationOffset = $_.PBRCustomImageLocation.offset
                PBRCustomImageLocationPath = $_.PBRCustomImageLocation.path
                PBRImageLocationGuid = $_.PBRImageLocation.guid
                PBRImageLocationId = $_.PBRImageLocation.id
                PBRImageLocationOffset = $_.PBRImageLocation.offset
                PBRImageLocationPath = $_.PBRImageLocation.path
                ScheduledOperation = $_.ScheduledOperation.state
                WinREStaged = $_.WinREStaged.state
                WinreBCD = $_.WinreBCD.id
                WinreLocationGuid = $WinreLocationGuid
                WinreLocationId = $WinreLocationId
                WinreLocationOffset = $WinreLocationOffset
                WinreLocationPath = $WinreLocationPath
                WindowsRElocation = '\\?\GLOBALROOT\device\harddisk' + $WinreLocationId + '\partition' + $WinreLocationPartition + $WinreLocationPath
                BootConfigurationDataBCD = $WinreBCD
            }
        }
        $ReAgentInfo
    }
}
