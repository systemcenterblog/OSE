function Get-MyBiosVersion {
    [CmdletBinding()]
    param ()

    $CimBios = Get-CimInstance -ClassName Win32_BIOS
    if ($CimBios.Manufacturer -match 'Lenovo') {
        $SystemBiosMajorVersion = $CimBios.SystemBiosMajorVersion
        $SystemBiosMinorVersion = $CimBios.SystemBiosMinorVersion
        $MyBiosVersion = "$SystemBiosMajorVersion.$SystemBiosMinorVersion"
        Return $MyBiosVersion
    }
    else {
        ((Get-CimInstance -ClassName Win32_BIOS).SMBIOSBIOSVersion).Trim()
    }
}
