function Get-OSDCloudREPartition {
    <#
    .SYNOPSIS
    OSDCloudRE: Gets the OSDCloudRE Partition object
    
    .DESCRIPTION
    OSDCloudRE: Gets the OSDCloudRE Partition object
    
    .EXAMPLE
    Get-OSDCloudREPartition
    
    .LINK
    https://github.com/OSDeploy/OSD/tree/master/Docs
    #>
    
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_Partition')]
    param ()
    Write-Verbose $MyInvocation.MyCommand

    Get-OSDCloudREVolume | Get-Partition
}
