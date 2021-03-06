function Get-MyBiosSerialNumber {
    [CmdletBinding()]
    param (
        [System.Management.Automation.SwitchParameter]$Brief
    )

    $Result = ((Get-CimInstance -ClassName Win32_BIOS).SerialNumber).Trim()

    if ($Brief -eq $true) {
        if ($null -eq $Result) {$Result = 'Unknown'}
        elseif ($Result -eq '') {$Result = 'Unknown'}

        #Allow only a-z A-Z 0-9
        $Result = $Result -replace '_'
        $Result = $Result -replace '\W'
    }
    $Result
}
