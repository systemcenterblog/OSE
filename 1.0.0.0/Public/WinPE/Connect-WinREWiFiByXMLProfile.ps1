function Connect-WinREWiFiByXMLProfile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( {
            if (Test-Path -Path $_) {
                $true
            } else {
                throw "$_ doesn't exists"
            }
            if ($_ -notmatch "\.xml$") {
                throw "$_ isn't xml file"
            }
            if (!(([xml](Get-Content $_ -Raw)).WLANProfile.Name) -or (([xml](Get-Content $_ -Raw)).WLANProfile.MSM.security.sharedKey.protected) -ne "false") {
                throw "$_ isn't valid Wi-Fi XML profile (is the password correctly in plaintext?). Use command like this, to create it: netsh wlan export profile name=`"MyWifiSSID`" key=clear folder=C:\Wifi"
            }
        })]
        [string] $wifiProfile
    )
    
    $SSID = ([xml](Get-Content $wifiProfile)).WLANProfile.Name
    Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Connecting to $SSID"

    # just for sure
    $null = Netsh WLAN delete profile "$SSID"

    # import wifi profile
    $null = Netsh WLAN add profile filename="$wifiProfile"

    # connect to network
    $result = Netsh WLAN connect name="$SSID"
    if ($result -ne "Connection request was completed successfully.") {
        throw "Connection to WIFI wasn't successful. Error was $result"
    }
}
