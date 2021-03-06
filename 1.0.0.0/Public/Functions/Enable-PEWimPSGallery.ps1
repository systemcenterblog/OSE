function Enable-PEWimPSGallery {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)]
        [string[]]$ImagePath,

        [Parameter(ValueFromPipelineByPropertyName)]
        [UInt32]$Index = 1
    )

    begin {
		#=================================================
		#	Blocks
		#=================================================
		Block-WinPE
		Block-StandardUser
		#=================================================
        $ErrorActionPreference = "Stop"
        #=================================================
    }
    process {
        foreach ($Input in $ImagePath) {
            #=================================================
            $WindowsImageDescription = (Get-WindowsImage -ImagePath $Input).ImageDescription
            Write-Verbose "WindowsImageDescription: $WindowsImageDescription"

            if (($WindowsImageDescription -match 'PE') -or ($WindowsImageDescription -match 'Recovery') -or ($WindowsImageDescription -match 'Setup')) {
                $MountMyWindowsImage = Mount-MyWindowsImage -ImagePath $Input -Index $Index
                $MountMyWindowsImage | Enable-PEWindowsImagePSGallery
                $MountMyWindowsImage | Dismount-MyWindowsImage -Save
            } else {
                Write-Warning "Windows Image does not appear to be WinPE, WinRE, or WinSE"
            }
            #=================================================
        }
    }
    end {}
}
