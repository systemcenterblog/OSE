function Get-MyComputerProduct {
    [CmdletBinding()]
    param ()

    $MyComputerManufacturer = Get-MyComputerManufacturer -Brief

    if ($MyComputerManufacturer -eq 'Dell') {
        $Result = (Get-CimInstance -ClassName CIM_ComputerSystem).SystemSKUNumber
    }
    elseif ($MyComputerManufacturer -eq 'HP')  {
        $Result = (Get-CimInstance -ClassName Win32_BaseBoard).Product
    }
    elseif ($MyComputerManufacturer -eq 'Lenovo')  {
        #Thanks Maurice
        $Result = (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty Model).SubString(0, 4)
    }
    elseif ($MyComputerManufacturer -eq 'Microsoft')  {
        #Surface_Book
        #Surface_Pro_3
        $Result = (Get-CimInstance -ClassName CIM_ComputerSystem).SystemSKUNumber
        #Surface Book
        #Surface Pro 3
        #((Get-WmiObject -Class Win32_BaseBoard).Product).Trim()
    }
    else {
        $Result = Get-MyComputerModel -Brief
    }
    
    if ($null -eq $Result) {
        $Result = 'Unknown'
    }

    ($Result).Trim()
}
