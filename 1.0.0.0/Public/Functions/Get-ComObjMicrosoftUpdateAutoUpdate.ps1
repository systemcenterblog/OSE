function Get-ComObjMicrosoftUpdateAutoUpdate{
    [CmdletBinding()]
    param ()

    Return (New-Object -ComObject Microsoft.Update.AutoUpdate).Settings
}
