function Find-OSDCloudFile {
    [CmdletBinding()]
    param (
        [string]$Name = '*.*',
        [string]$Path = '\OSDCloud\'
    )
    $Results = @()
    $Results = Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        Get-ChildItem "$($_.Name):$Path" -Include "$Name" -File -Recurse -Force -ErrorAction Ignore
    }
    $Results
}
