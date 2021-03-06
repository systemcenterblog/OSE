function Get-ComObjects {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
        ParameterSetName='FilterByName')]
        [string]$Filter,
 
        [Parameter(Mandatory=$true,
        ParameterSetName='ListAllComObjects')]
        [System.Management.Automation.SwitchParameter]$ListAll
    )
 
    $ListofObjects = Get-ChildItem HKLM:\Software\Classes -ErrorAction SilentlyContinue | Where-Object {
        $_.PSChildName -match '^\w+\.\w+$' -and (Test-Path -Path "$($_.PSPath)\CLSID")
    } | Select-Object -ExpandProperty PSChildName
 
    if ($Filter) {
        $ListofObjects | Where-Object {$_ -like $Filter}
    } else {
        $ListofObjects
    }
}
