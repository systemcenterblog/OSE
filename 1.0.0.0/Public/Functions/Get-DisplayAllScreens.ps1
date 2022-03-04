function Get-DisplayAllScreens {
    [CmdletBinding()]
    param ()
  
    Add-Type -Assembly System.Windows.Forms
    Return ([System.Windows.Forms.Screen]::AllScreens | Select-Object * | Sort-Object DeviceName)
}
