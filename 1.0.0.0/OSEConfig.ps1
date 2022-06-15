#======================================================================================
#	Author: Jonathan Proctor (copied/Ammended from David Segura)
#	Version: 1.0
#	https://www.OSEDeploy.com/
#======================================================================================
#   Requirements
#======================================================================================
$ErrorActionPreference = 'SilentlyContinue'
#$VerbosePreference = 'Continue'
#======================================================================================
#   Set OSEDeploy
#======================================================================================
$OSEDeploy = "$env:ProgramData\OSEDeploy"
$OSEConfig = "$env:ProgramData\OSEConfig"
$OSEConfigLogs = "$OSEDeploy\Logs\OSEConfig"
$ScriptName = $MyInvocation.MyCommand.Name
$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path -Parent
$Host.UI.RawUI.WindowTitle = "$ScriptDirectory\$ScriptName"
#======================================================================================
#	Create the Log Directory
#======================================================================================
if (!(Test-Path $OSEConfigLogs)) {New-Item -ItemType Directory -Path $OSEConfigLogs}
#======================================================================================
#	Start the Transcript
#======================================================================================
$LogName = "$ScriptName-$((Get-Date).ToString('yyyy-MM-dd-HHmmss')).log"
Start-Transcript -Path (Join-Path $OSEConfigLogs $LogName)
Write-Host ""
Write-Host "Starting $ScriptName from $ScriptDirectory" -ForegroundColor Yellow
#======================================================================================
#   Remove Existing OSEConfig
#======================================================================================
if ($ScriptDirectory -ne $OSEConfig) {
	if (Test-Path $OSEConfig) {
		Write-Host "Removing existing $OSEConfig..." -ForegroundColor Yellow
		Remove-Item -Path $OSEConfig -Recurse -Force
    }
}
#======================================================================================
#   Check for Provisioning Package
#====================================================================================== 
if ($ScriptDirectory -like "*ProvisioningPkgTmp*") {
    Write-Host "OSEConfig is running from a Provisioning Package ..." -ForegroundColor Yellow
    #======================================================================================
    #   Expand Provisioning Package
    #====================================================================================== 
    if (Test-Path "$ScriptDirectory\OSEConfig.cab") {
        if (!(Test-Path $OSEConfig)) {New-Item -ItemType Directory -Path $OSEConfig}
        Write-Host "Expanding '$ScriptDirectory\OSEConfig.cab' to '$OSEConfig'..." -ForegroundColor Yellow
        expand "$ScriptDirectory\OSEConfig.cab" $OSEConfig -F:*
    }
} else {
    #======================================================================================
    #   Copy Files
    #====================================================================================== 
    if ($ScriptDirectory -ne $OSEConfig) {
        Write-Host "Copying '$ScriptDirectory' to '$OSEConfig'..." -ForegroundColor Yellow
        Copy-Item -Path $ScriptDirectory -Destination $OSEConfig -Recurse
    }
}
#======================================================================================
#	Capture the Environment Variables in the Log
#======================================================================================
Get-Childitem -Path Env:* | Sort-Object Name | Format-Table
#======================================================================================
#	Increase the Screen Buffer size
#======================================================================================
#	This entry allows increased scrolling of the console windows
if (!(Test-Path "HKCU:\Console")) {
	New-Item -Path "HKCU:\Console" -Force | Out-Null
	New-ItemProperty -Path HKCU:\Console ScreenBufferSize -Value 589889656 -PropertyType DWORD -Force | Out-Null
}
#======================================================================================
#	Execute PowerShell files in OSEConfig
#======================================================================================
Write-Host ""
$OSEConfigChild = Get-ChildItem $OSEConfig -Directory
foreach ($item in $OSEConfigChild) {
    Write-Host "$($item.FullName)" -ForegroundColor Green
    $OSEConfigScripts = Get-ChildItem $item.FullName -Filter *.ps1 -File
	
    foreach ($script in $OSEConfigScripts) {
        Write-Host "Executing $($script.FullName)"
        #======================================================================================
        #	Execute Provisioning Package Minimized
        #   Change WindowStyle to Hidden when testing is complete
        #======================================================================================
        if (Test-Path "$ScriptDirectory\OSEConfig.cab") {
            Start-Process PowerShell.exe -ArgumentList "-file `"$($script.FullName)`"" -Wait -WindowStyle Minimized
        #======================================================================================
        #	Execute Standard PowerShell Script
        #   Choose proper WindowStyle
        #======================================================================================
        } else {
            #Start-Process PowerShell.exe -ArgumentList "-file `"$($script.FullName)`"" -Wait
            #Start-Process PowerShell.exe -ArgumentList "-file `"$($script.FullName)`"" -Wait -NoNewWindow
            Start-Process PowerShell.exe -ArgumentList "-file `"$($script.FullName)`"" -Wait -WindowStyle Minimized
            #Start-Process PowerShell.exe -ArgumentList "-file `"$($script.FullName)`"" -Wait -WindowStyle Maximized
            #Start-Process PowerShell.exe -ArgumentList "-file `"$($script.FullName)`"" -Wait -WindowStyle Hidden
        }
    }
    Write-Host ""
}
#======================================================================================
#	Enable the following lines for testing as needed
#	Start-Process PowerShell_ISE.exe -Wait
#	Read-Host -Prompt "Press Enter to Continue"
#======================================================================================
Stop-Transcript
#======================================================================================