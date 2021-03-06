function Copy-PSModuleToWindowsImage {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()]
        [String[]]$Name,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Restricted','AllSigned','RemoteSigned','Unrestricted','Bypass','Undefined')]
        [string]$ExecutionPolicy,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string[]]$Path
    )

    begin {
        #=================================================
        #   Require Admin Rights
        #=================================================
        if ((Get-OSDGather -Property IsAdmin) -eq $false) {
            Write-Warning "$($MyInvocation.MyCommand) requires Admin Rights ELEVATED"
            Break
        }
        #=================================================
        #   Get-WindowsImage Mounted
        #=================================================
        if ($null -eq $Path) {
            $Path = (Get-WindowsImage -Mounted | Select-Object -Property Path).Path
        }
        #=================================================
    }
    process {
        foreach ($Input in $Path) {
            #=================================================
            #   Path
            #=================================================
            $MountPath = (Get-Item -Path $Input | Select-Object FullName).FullName
            Write-Verbose "Path: $MountPath"
            #=================================================
            #   Validate Mount Path
            #=================================================
            if (-not (Test-Path $Input -ErrorAction SilentlyContinue)) {
                Write-Warning "Unable to locate Mounted WindowsImage at $Input"
                Break
            }
            #=================================================
            #   Copy-PSoduleToFolder
            #=================================================
            Copy-PSModuleToFolder -Name $Name -Destination "$MountPath\Program Files\WindowsPowerShell\Modules" -RemoveOldVersions
            #=================================================
            #   Set-WindowsImageExecutionPolicy
            #=================================================
            if ($ExecutionPolicy) {
                Set-WindowsImageExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Path $MountPath
            }
            #=================================================
            #   Return for PassThru
            #=================================================
            Return Get-WindowsImage -Mounted | Where-Object {$_.Path -eq $MountPath}
            #=================================================
        }
    }
    end {}
}
