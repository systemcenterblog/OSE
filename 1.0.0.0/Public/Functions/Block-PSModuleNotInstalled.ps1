function Block-PSModuleNotInstalled {
    [CmdletBinding()]
    param (
        [string]$ModuleName = 'OSD',
        [System.Management.Automation.SwitchParameter]$Warn,
        [System.Management.Automation.SwitchParameter]$Pause
    )
    $CallingFunction = (Get-PSCallStack)[1].InvocationInfo.Line
    $Message = "[$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))] $CallingFunction requires PowerShell Module $ModuleName to be installed"
        
    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        Write-Warning $Message
        if ($PSBoundParameters.ContainsKey('Pause')) {
            [void]('Press Enter to Continue')
        }
        if (-NOT ($PSBoundParameters.ContainsKey('Warn'))) {
            Break
        }
    }
}
