function Get-DisplayVirtualScreen {
    [CmdletBinding()]
    param ()
  
    Add-Type -Assembly System.Windows.Forms
    Return ([System.Windows.Forms.SystemInformation]::VirtualScreen | Select-Object Width, Height, X, Y, Left, Top, Right, Bottom, Size)
}
