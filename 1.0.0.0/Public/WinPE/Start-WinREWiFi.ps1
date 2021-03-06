function Start-WinREWiFi {
    [CmdletBinding()]
    param (
        [string] $wifiProfile
    )
    #=================================================
    #	Block
    #=================================================
    #Block-WinOS
    Block-PowerShellVersionLt5
    #=================================================
    #	Header
    #=================================================
    Write-Host -ForegroundColor DarkGray "========================================================================="
    Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) $($MyInvocation.MyCommand.Name) " -NoNewline
    Write-Host -ForegroundColor Green 'OK'
    #=================================================
    #	Test Internet Connection
    #=================================================
    Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Test-WebConnection google.com " -NoNewline

    if (Test-WebConnection -Uri 'google.com') {
        Write-Host -ForegroundColor Green 'OK'
        Write-Host -ForegroundColor DarkGray "You are already connected to the Internet"
        Write-Host -ForegroundColor DarkGray "Start-WinREWiFi will not continue"
        $StartWinREWiFi = $false
    }
    else {
        Write-Host -ForegroundColor Red 'FAIL'
        $StartWinREWiFi = $true
    }
    #=================================================
    #   Test WinRE
    #=================================================
    if ($StartWinREWiFi) {
        Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Testing required WinRE content " -NoNewline

        if (!(Test-Path "$ENV:SystemRoot\System32\dmcmnutils.dll")) {
            #Write-Warning "Missing required $ENV:SystemRoot\System32\dmcmnutils.dll"
            $StartWinREWiFi = $false
        }
        if (!(Test-Path "$ENV:SystemRoot\System32\mdmpostprocessevaluator.dll")) {
            #Write-Warning "Missing required $ENV:SystemRoot\System32\mdmpostprocessevaluator.dll"
            $StartWinREWiFi = $false
        }
        if (!(Test-Path "$ENV:SystemRoot\System32\mdmregistration.dll")) {
            #Write-Warning "Missing required $ENV:SystemRoot\System32\mdmregistration.dll"
            $StartWinREWiFi = $false
        }
        if (!(Test-Path "$ENV:SystemRoot\System32\raschap.dll")) {
            #Write-Warning "Missing required $ENV:SystemRoot\System32\raschap.dll"
            $StartWinREWiFi = $false
        }
        if (!(Test-Path "$ENV:SystemRoot\System32\raschapext.dll")) {
            #Write-Warning "Missing required $ENV:SystemRoot\System32\raschapext.dll"
            $StartWinREWiFi = $false
        }
        if (!(Test-Path "$ENV:SystemRoot\System32\rastls.dll")) {
            #Write-Warning "Missing required $ENV:SystemRoot\System32\rastls.dll"
            $StartWinREWiFi = $false
        }
        if (!(Test-Path "$ENV:SystemRoot\System32\rastlsext.dll")) {
            #Write-Warning "Missing required $ENV:SystemRoot\System32\rastlsext.dll"
            $StartWinREWiFi = $false
        }
        if ($StartWinREWiFi) {
            Write-Host -ForegroundColor Green 'OK'
        }
        else {
            Write-Host -ForegroundColor Red 'FAIL'
        }
    }
    #=================================================
    #	WlanSvc
    #=================================================
    if ($StartWinREWiFi) {
        Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Starting WlanSvc Service" -NoNewline
        if (Get-Service -Name WlanSvc) {
            if ((Get-Service -Name WlanSvc).Status -ne 'Running') {
                Get-Service -Name WlanSvc | Start-Service
                Start-Sleep -Seconds 10
    
            }
        }
        Write-Host -ForegroundColor Green 'OK'
    }
    #=================================================
    #	Test Wi-Fi Adapter
    #=================================================
    if ($StartWinREWiFi) {
        Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Testing Wi-Fi Network Adapter " -NoNewline
        #$WirelessNetworkAdapter = Get-CimInstance -ClassName CIM_NetworkAdapter | Where-Object {$_.NetConnectionID -eq 'Wi-Fi'}
        $WirelessNetworkAdapter = Get-WmiObject -ClassName Win32_NetworkAdapter | Where-Object {$_.NetConnectionID -eq 'Wi-Fi'}
        #$WirelessNetworkAdapter = Get-SmbClientNetworkInterface | Where-Object {$_.FriendlyName -eq 'Wi-Fi'}
        if ($WirelessNetworkAdapter) {
            $StartWinREWiFi = $true
            Write-Host -ForegroundColor Green 'OK'
            Write-Host -ForegroundColor Gray "  Name: $($WirelessNetworkAdapter.Name)"
            Write-Host -ForegroundColor Gray "  Description: $($WirelessNetworkAdapter.Description)"
            #Write-Host -ForegroundColor Gray "  Speed: $($WirelessNetworkAdapter.Speed)"
            Write-Host -ForegroundColor Gray "  AdapterType: $($WirelessNetworkAdapter.AdapterType)"
            #Write-Host -ForegroundColor Gray "  Installed: $($WirelessNetworkAdapter.Installed)"
            #Write-Host -ForegroundColor Gray "  InterfaceIndex: $($WirelessNetworkAdapter.InterfaceIndex)"
            Write-Host -ForegroundColor Gray "  MACAddress: $($WirelessNetworkAdapter.MACAddress)"
            #Write-Host -ForegroundColor Gray "  NetEnabled: $($WirelessNetworkAdapter.NetEnabled)"
            #Write-Host -ForegroundColor Gray "  PhysicalAdapter: $($WirelessNetworkAdapter.PhysicalAdapter)"
            Write-Host -ForegroundColor Gray "  PNPDeviceID: $($WirelessNetworkAdapter.PNPDeviceID)"
        }
        else {
            $PnPEntity = Get-WmiObject -ClassName Win32_PnPEntity | Where-Object {$_.Status -eq 'Error'} |  Where-Object {$_.Name -match 'Net'}

            Write-Host -ForegroundColor Red 'FAIL'
            Write-Warning "Could not find an installed Wi-Fi Network Adapter"
            if ($PnPEntity) {
                Write-Warning "Drivers may need to be added to WinPE for the following hardware"
                foreach ($Item in $PnPEntity) {
                    Write-Warning "$($Item.Name): $($Item.DeviceID)"
                }
                Start-Sleep -Seconds 10
            }
            else {
                Write-Warning "Drivers may need to be added to WinPE"
            }
            $StartWinREWiFi = $false
        }
    }
    #=================================================
    #	Test Wi-Fi Connection
    #=================================================
    if ($StartWinREWiFi) {
        Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Testing Wi-Fi Network Connection " -NoNewline
        if ($WirelessNetworkAdapter.NetEnabled -eq $true) {
            Write-Host -ForegroundColor Green ''
            Write-Warning "Wireless is already connected ... Disconnecting"
            (Get-WmiObject -ClassName Win32_NetworkAdapter | Where-Object {$_.NetConnectionID -eq 'Wi-Fi'}).disable() | Out-Null
            Start-Sleep -Seconds 5
            (Get-WmiObject -ClassName Win32_NetworkAdapter | Where-Object {$_.NetConnectionID -eq 'Wi-Fi'}).enable() | Out-Null
            Start-Sleep -Seconds 5
            $StartWinREWiFi = $true
        }
        else {
            Write-Host -ForegroundColor Green 'OK'
        }
    }
    #=================================================
    #   Connect
    #=================================================
    if ($StartWinREWiFi) {
            if ($wifiProfile -and (Test-Path $wifiProfile)) {
                Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Starting unattended Wi-Fi connection " -NoNewline
            } else {
                Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Starting Wi-Fi Network Menu " -NoNewline
            }
            Write-Host -ForegroundColor Green 'OK'
            Write-Host -ForegroundColor DarkGray "========================================================================="

        while (((Get-CimInstance -ClassName Win32_NetworkAdapter | Where-Object {$_.NetConnectionID -eq 'Wi-Fi'}).NetEnabled) -eq $false) {
            Start-Sleep -Seconds 3

            $StartWinREWiFi = 0
            # make checks on start of evert cycle because in case of failure, profile will be deleted
            if ($wifiProfile -and (Test-Path $wifiProfile)) { ++$StartWinREWiFi }
    
            if ($StartWinREWiFi) {
                # use saved wi-fi profile to make the unattended connection
                try {
                    Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Establishing a connection using $wifiProfile"
                    Connect-WinREWiFiByXMLProfile $wifiProfile -ErrorAction Stop
                } catch {
                    Write-Warning $_
                    # to avoid infinite loop of tries
                    Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Removing invalid Wi-Fi profile '$wifiProfile'"
                    Remove-Item $wifiProfile -Force
                    continue
                }
            } else {
                # show list of available SSID to make interactive connection
                $SSIDList = Get-WinREWiFi
                if ($SSIDList) {
                    #show list of available SSID
                    $SSIDList | Sort-Object Signal -Descending | Select-Object Signal, Index, SSID, Authentication, Encryption, NetworkType | Format-Table
        
                    $SSIDListIndex = $SSIDList.index
                    $SSIDIndex = ""
                    while ($SSIDIndex -notin $SSIDListIndex) {
                        $SSIDIndex = Read-Host "Select the Index of Wi-Fi Network to connect or CTRL+C to quit"
                    }
        
                    $SSID = $SSIDList | Where-Object { $_.index -eq $SSIDIndex } | Select-Object -exp SSID
        
                    # connect to selected Wi-Fi
                    Write-Host -ForegroundColor DarkGray "========================================================================="
                    Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Establishing a connection to SSID $SSID"
                    try {
                        Connect-WinREWiFi $SSID -ErrorAction Stop
                    } catch {
                        Write-Warning $_
                        continue
                    }
                } else {
                    Write-Warning "No Wi-Fi network found. Move closer to AP or use ethernet cable instead."
                }
            }

            if ($StartWinREWiFi) {
                $text = "to Wi-Fi using $wifiProfile"
            } else {
                $text = "to SSID $SSID"
            }
            Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Waiting for a connection $text"
            Start-Sleep -Seconds 15
        
            $i = 30
            while ((((Get-CimInstance -ClassName Win32_NetworkAdapter | Where-Object {$_.NetConnectionID -eq 'Wi-Fi'}).NetEnabled) -eq $false) -and $i -gt 0) {
                --$i
                Write-Host -ForegroundColor DarkGray "Waiting for Wi-Fi Connection ($i)"
                Start-Sleep -Seconds 1
            }

            # connection to network can take a while
            #$i = 30
            #while (!(Test-WebConnection -Uri 'github.com') -and $i -gt 0) { --$i; "Waiting for Internet connection ($i)" ; Start-Sleep -Seconds 1 }
        }
        Get-SmbClientNetworkInterface | Where-Object {$_.FriendlyName -eq 'Wi-Fi'} | Format-List
    }
    Start-Sleep -Seconds 5
}
