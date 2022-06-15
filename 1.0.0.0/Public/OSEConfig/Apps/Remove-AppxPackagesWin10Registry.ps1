#======================================================================================
#	Author: David Segura
#	Version: 18.9.3
#	https://www.osdeploy.com/
#======================================================================================
#	Requirements
#======================================================================================
$RequiresOS = "Windows 10"
$RequiresOSReleaseId = ""
$RequiresOSBuild = ""
$ErrorActionPreference = 'SilentlyContinue'
#$VerbosePreference = 'Continue'
#======================================================================================
#   Set OSDeploy
#======================================================================================
$OSDeploy = "$env:ProgramData\OSDeploy"
$OSConfig = "$env:ProgramData\OSConfig"
$OSConfigLogs = "$OSDeploy\Logs\OSConfig"
$ScriptName = $MyInvocation.MyCommand.Name
$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path -Parent
$Host.UI.RawUI.WindowTitle = "$ScriptDirectory\$ScriptName"
#======================================================================================
#	Create the Log Directory
#======================================================================================
if (!(Test-Path $OSConfigLogs)) {New-Item -ItemType Directory -Path $OSConfigLogs}
#======================================================================================
#	Start the Transcript
#======================================================================================
$LogName = "$ScriptName-$((Get-Date).ToString('yyyy-MM-dd-HHmmss')).log"
Start-Transcript -Path (Join-Path $OSConfigLogs $LogName)
Write-Host ""
Write-Host "Starting $ScriptName from $ScriptDirectory" -ForegroundColor Yellow
#======================================================================================
#	System Information
#======================================================================================
$SystemManufacturer = (Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\SystemInformation).SystemManufacturer.Trim()
$SystemProductName = (Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\SystemInformation).SystemProductName.Trim()
$BIOSVersion = (Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\SystemInformation).BIOSVersion.Trim()
$BIOSReleaseDate = (Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\SystemInformation).BIOSReleaseDate.Trim()
if ($SystemManufacturer -like "*Dell*") {$SystemManufacturer = "Dell"}
Write-Host "SystemManufacturer: $SystemManufacturer" -ForegroundColor Cyan
Write-Host "SystemProductName: $SystemProductName" -ForegroundColor Cyan
Write-Host "BIOSVersion: $BIOSVersion" -ForegroundColor Cyan
Write-Host "BIOSReleaseDate: $BIOSReleaseDate" -ForegroundColor Cyan
Write-Host ""
#======================================================================================
#	Windows Information
#======================================================================================
if (Test-Path -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion") {
	$ProductName = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").ProductName.Trim()
	$EditionID = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").EditionID.Trim()
	if ($ProductName -like "*Windows 10*") {
		$CompositionEditionID = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").CompositionEditionID.Trim()
		$ReleaseId = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").ReleaseId.Trim()
	}
	$CurrentBuild = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").CurrentBuild.Trim()
	$CurrentBuildNumber = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").CurrentBuildNumber.Trim()
	$CurrentVersion = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").CurrentVersion.Trim()
	$InstallationType = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").InstallationType.Trim()
	$RegisteredOwner = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").RegisteredOwner.Trim()
	$RegisteredOrganization = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").RegisteredOrganization.Trim()
} else {
	$ProductName = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion").ProductName.Trim()
	$EditionID = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion").EditionID.Trim()
	if ($ProductName -like "*Windows 10*") {
		$CompositionEditionID = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion").CompositionEditionID.Trim()
		$ReleaseId = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion").ReleaseId.Trim()
	}
	$CurrentBuild = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion").CurrentBuild.Trim()
	$CurrentBuildNumber = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion").CurrentBuildNumber.Trim()
	$CurrentVersion = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion").CurrentVersion.Trim()
	$InstallationType = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion").InstallationType.Trim()
	$RegisteredOwner = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion").RegisteredOwner.Trim()
	$RegisteredOrganization = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion").RegisteredOrganization.Trim()
}

if ($env:PROCESSOR_ARCHITECTURE -like "*64") {
	#64-bit
	$Arch = "x64"
	$Bits = "64-bit"
} else {
	#32-bit
	$Arch = "x86"
	$Bits = "32-bit"
}

if ($env:SystemDrive -eq "X:") {
	$IsWinPE = "True"
	Write-Host "System is running in WinPE" -ForegroundColor Green
} else {
	$IsWinPE = "False"
}

Write-Host "ProductName: $ProductName" -ForegroundColor Cyan
Write-Host "Architecture: $Arch" -ForegroundColor Cyan
Write-Host "IsWinPE: $IsWinPE" -ForegroundColor Cyan
Write-Host "EditionID: $EditionID" -ForegroundColor Cyan
Write-Host "CompositionEditionID: $CompositionEditionID" -ForegroundColor Cyan
Write-Host "ReleaseId: $ReleaseId" -ForegroundColor Cyan
Write-Host "CurrentBuild: $CurrentBuild" -ForegroundColor Cyan
Write-Host "CurrentBuildNumber: $CurrentBuildNumber" -ForegroundColor Cyan
Write-Host "CurrentVersion: $CurrentVersion" -ForegroundColor Cyan
Write-Host "InstallationType: $InstallationType" -ForegroundColor Cyan
Write-Host "RegisteredOwner: $RegisteredOwner" -ForegroundColor Cyan
Write-Host "RegisteredOrganization: $RegisteredOrganization" -ForegroundColor Cyan
Write-Host ""
#======================================================================================
#	Filter Requirements
#======================================================================================
if (!(Test-Path variable:\RequiresOS)) {
	Write-Host "OS Build requirement does not exist"
} else {
	if ($RequiresOS -eq "") {
		Write-Host "Operating System requirement is empty"
	} elseif ($ProductName -like "*$RequiresOS*") {
		Write-Host "Operating System requirement PASSED" -ForegroundColor Green
	} else {
		Write-Host "Operating System requirement FAILED ... Exiting" -ForegroundColor Red
		Stop-Transcript
		Return
	}
}

if (!(Test-Path variable:\RequiresOSReleaseId)) {
	Write-Host "OS Release Id requirement does not exist"
} else {
	if ($RequiresOSReleaseId -eq "") {
		Write-Host "OS Release Id requirement is empty"
	} elseif ($ReleaseId -eq $RequiresOSReleaseId) {
		Write-Host "OS Release Id requirement PASSED" -ForegroundColor Green
	} else {
		Write-Host "OS Release Id requirement FAILED ... Exiting" -ForegroundColor Red
		Stop-Transcript
		Return
	}
}

if (!(Test-Path variable:\RequiresOSBuild)) {
	Write-Host "OS Build requirement does not exist"
} else {
	if ($RequiresOSBuild -eq "") {
		Write-Host "OS Build requirement is empty"
	} elseif ($CurrentBuild -eq $RequiresOSBuild) {
		Write-Host "OS Build requirement PASSED" -ForegroundColor Green
	} else {
		Write-Host "OS Build requirement FAILED" -ForegroundColor Red
	}
}
Write-Host ""
#======================================================================================
#	Main
#======================================================================================
#	Appx Packages
#======================================================================================
$AppBlackList =
"Microsoft.3DBuilder_8wekyb3d8bbwe",
"Microsoft.BingWeather_8wekyb3d8bbwe",
"Microsoft.DesktopAppInstaller_8wekyb3d8bbwe",
"Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe",
"Microsoft.GetHelp_8wekyb3d8bbwe",
"Microsoft.Getstarted_8wekyb3d8bbwe",
"Microsoft.Messaging_8wekyb3d8bbwe",
"Microsoft.Microsoft3DViewer_8wekyb3d8bbwe",
"Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe",
"Microsoft.OneConnect_8wekyb3d8bbwe",
"Microsoft.People_8wekyb3d8bbwe",
"Microsoft.Print3D_8wekyb3d8bbwe",
"Microsoft.SkypeApp_kzf8qxf38zg5c",
"Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe",
"Microsoft.Wallet_8wekyb3d8bbwe",
"microsoft.windowscommunicationsapps_8wekyb3d8bbwe",
"Microsoft.WindowsMaps_8wekyb3d8bbwe",
"Microsoft.XboxApp_8wekyb3d8bbwe",
"Microsoft.XboxGameOverlay_8wekyb3d8bbwe",
"Microsoft.XboxGamingOverlay_8wekyb3d8bbwe",
"Microsoft.XboxIdentityProvider_8wekyb3d8bbwe",
"Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe",
"Microsoft.Xbox.TCUI_8wekyb3d8bbwe",
"Microsoft.YourPhone_8wekyb3d8bbwe",
"Microsoft.ZuneMusic_8wekyb3d8bbwe",
"Microsoft.ZuneVideo_8wekyb3d8bbwe"
				
$AppWhiteList =	
"Microsoft.HEIFImageExtension",
"Microsoft.MicrosoftStickyNotes",
"Microsoft.MixedReality.Portal",
"Microsoft.MSPaint",
"Microsoft.Office.OneNote",
"Microsoft.ScreenSketch",
"Microsoft.StorePurchaseApp",
"Microsoft.VP9VideoExtensions",
"Microsoft.WebMediaExtensions",
"Microsoft.WebpImageExtension",
"Microsoft.Windows.Photos",
"Microsoft.WindowsAlarms",
"Microsoft.WindowsCalculator",
"Microsoft.WindowsCamera",
"Microsoft.WindowsSoundRecorder",
"Microsoft.WindowsStore"


#======================================================================================
#	Remove Appx Packages
#======================================================================================
ForEach ($App in $AppBlackList)
{
		Write-Host "Creating Deprovisioned Regsitry key for PackageName: $App" -ForegroundColor Green
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\$App" -Force
	
	} 

#======================================================================================
#	Log AppxPackages
#======================================================================================
$AppLogs = "$OSDeploy\Apps"
if (!(Test-Path $AppLogs)) {New-Item -ItemType Directory -Path $AppLogs}

$LogAppxPackages = $(Join-Path $AppLogs "AppxPackages-$((Get-Date).ToString('yyyy-MM-dd-HHmmss')).txt")
$LogProvisionedAppxPackages = $(Join-Path $AppLogs "ProvisionedAppxPackages-$((Get-Date).ToString('yyyy-MM-dd-HHmmss')).txt")

Get-AppxPackage | Sort Name | Select Name | Out-File -FilePath $LogAppxPackages -Verbose
Get-AppxPackage | Sort Name | Out-File -FilePath $LogAppxPackages -Append -Verbose

Get-ProvisionedAppxPackage -Online | Sort DisplayName | Select DisplayName | Out-File -FilePath $LogProvisionedAppxPackages -Verbose
Get-ProvisionedAppxPackage -Online | Sort DisplayName | Out-File -FilePath $LogProvisionedAppxPackages -Append -Verbose
#======================================================================================
#	Enable the following lines for testing as needed
#	Start-Process PowerShell_ISE.exe -Wait
#	Read-Host -Prompt "Press Enter to Continue"
#======================================================================================
Stop-Transcript
#======================================================================================