function Block-WindowsVersionNe10 {
    [CmdletBinding()]
    param (
        [System.Management.Automation.SwitchParameter]$Warn,
        [System.Management.Automation.SwitchParameter]$Pause
    )
    $CallingFunction = (Get-PSCallStack)[1].InvocationInfo.Line
    $Message = "[$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))] $CallingFunction requires Windows with a Major version 10 or greater"
        
    if ([System.Environment]::OSVersion.Version.Major -ne 10) {
        Write-Warning $Message
        if ($PSBoundParameters.ContainsKey('Pause')) {
            [void]('Press Enter to Continue')
        }
        if (-NOT ($PSBoundParameters.ContainsKey('Warn'))) {
            Break
        }
    }
}
