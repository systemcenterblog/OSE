function Get-DisplayPrimaryBitmapSize {
    [CmdletBinding()]
    param ()
  
    $GetDisplayPrimaryMonitorSize = Get-DisplayPrimaryMonitorSize
    $GetDisplayPrimaryScaling = Get-DisplayPrimaryScaling

    foreach ($Item in $GetDisplayPrimaryMonitorSize) {
        [int32]$Item.Width = [math]::round($(($Item.Width * $GetDisplayPrimaryScaling) / 100), 0)
        [int32]$Item.Height = [math]::round($(($Item.Height * $GetDisplayPrimaryScaling) / 100), 0)
    }

    Return $GetDisplayPrimaryMonitorSize
}
