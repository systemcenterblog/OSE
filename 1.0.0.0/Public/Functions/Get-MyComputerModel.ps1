function Get-MyComputerModel {
    [CmdletBinding()]
    param (
        #Normalize the Return
        [System.Management.Automation.SwitchParameter]$Brief
    )

    $MyComputerManufacturer = Get-MyComputerManufacturer -Brief

    if ($MyComputerManufacturer -eq 'Lenovo') {
        $MyComputerModel = ((Get-CimInstance -ClassName Win32_ComputerSystemProduct).Version).Trim()
    }
    else {
        $MyComputerModel = ((Get-CimInstance -ClassName CIM_ComputerSystem).Model).Trim()
    }
    Write-Verbose $MyComputerModel

    if ($Brief -eq $true) {
        if ($MyComputerModel -eq '') {$MyComputerModel = 'OEM'}
        if ($MyComputerModel -match 'to be filled') {$MyComputerModel = 'OEM'}
        if ($null -eq $MyComputerModel) {$MyComputerModel = 'OEM'}
    }
    $MyComputerModel
}
