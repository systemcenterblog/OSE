function Set-ClipboardScreenshot {
    [CmdletBinding()]
    param ()

    #=================================================
    #	Load Assemblies
    #=================================================
    Add-Type -Assembly System.Drawing
    Add-Type -Assembly System.Windows.Forms
    #=================================================
    #	Display Information
    #=================================================
    $GetDisplayVirtualScreen = Get-DisplayVirtualScreen
    #=================================================
    #	Display Number
    #=================================================
    $GetDisplayPrimaryBitmapSize = Get-DisplayPrimaryBitmapSize
    #Write-Verbose "Width: $($GetDisplayPrimaryBitmapSize.Width)" -Verbose
    #Write-Verbose "Height: $($GetDisplayPrimaryBitmapSize.Height)" -Verbose
    $ScreenShotBitmap = New-Object System.Drawing.Bitmap $GetDisplayPrimaryBitmapSize.Width, $GetDisplayPrimaryBitmapSize.Height
    $ScreenShotGraphics = [System.Drawing.Graphics]::FromImage($ScreenShotBitmap)
    #Write-Verbose "X: $($GetDisplayVirtualScreen.X)" -Verbose
    #Write-Verbose "Y: $($GetDisplayVirtualScreen.Y)" -Verbose
    #Write-Verbose "Size: $($GetDisplayVirtualScreen.Size)" -Verbose
    $ScreenShotGraphics.CopyFromScreen($GetDisplayVirtualScreen.X, $GetDisplayVirtualScreen.Y, $GetDisplayVirtualScreen.X, $GetDisplayVirtualScreen.Y, $GetDisplayVirtualScreen.Size)
    #=================================================
    #	Copy the ScreenShot to the Clipboard
    #   https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.clipboard.setimage?view=net-5.0
    #=================================================
    [System.Windows.Forms.Clipboard]::SetImage($ScreenShotBitmap)
    Return Get-Clipboard -Format Image
}
