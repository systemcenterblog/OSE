function Block-WinPE {
    [CmdletBinding()]
    param (
        [System.Management.Automation.SwitchParameter]$Warn,
        [System.Management.Automation.SwitchParameter]$Pause
    )
    $CallingFunction = (Get-PSCallStack)[1].InvocationInfo.Line
    $Message = "[$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))] $CallingFunction cannot be run from WinPE"
        
    if ((Get-OSDGather -Property IsWinPE)) {
        Write-Warning $Message
        if ($PSBoundParameters.ContainsKey('Pause')) {
            [void]('Press Enter to Continue')
        }
        if (-NOT ($PSBoundParameters.ContainsKey('Warn'))) {
            Break
        }
    }
}
