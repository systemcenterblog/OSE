function Get-OSDCloudREVolume {
    <#
    .SYNOPSIS
    OSDCloudRE: Gets the OSDCloudRE Volume object

    .DESCRIPTION
    OSDCloudRE: Gets the OSDCloudRE Volume object

    .EXAMPLE
    Get-OSDCloudREVolume

    .LINK
    https://github.com/OSDeploy/OSD/tree/master/Docs
    #>
    
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_Volume')]
    param ()
    Write-Verbose $MyInvocation.MyCommand
    
    Get-Volume | Where-Object {$_.FileSystemLabel -match 'OSDCloudRE'}
}
