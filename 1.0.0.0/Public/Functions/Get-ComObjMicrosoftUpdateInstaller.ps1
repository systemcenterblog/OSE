function Get-ComObjMicrosoftUpdateInstaller {
    [CmdletBinding()]
    param ()

    Return New-Object -ComObject Microsoft.Update.Installer
}
