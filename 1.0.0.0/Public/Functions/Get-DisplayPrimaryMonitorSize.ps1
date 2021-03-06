function Get-DisplayPrimaryMonitorSize {
    [CmdletBinding()]
    param ()
  
    Add-Type -Assembly System.Windows.Forms
    Return ([System.Windows.Forms.SystemInformation]::PrimaryMonitorSize | Select-Object Width, Height)
}
