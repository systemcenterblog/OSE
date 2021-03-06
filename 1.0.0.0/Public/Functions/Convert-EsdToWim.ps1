function Convert-EsdToWim {
    [CmdletBinding(PositionalBinding = $false)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('FullName')]
        [string]$esdFullName,
        [string]$wimFullName
    )
    #=================================================
    #	Blocks
    #=================================================
    Block-StandardUser
    Block-WindowsVersionNe10
    Block-WindowsReleaseIdLt1703
    #=================================================
    #	Test-WindowsImage
    #=================================================
    $TestWindowsImage = Test-WindowsImage -ImagePath $esdFullName
    #=================================================
    #	Test Destination
    #=================================================
    if ($TestWindowsImage) {
        $esdGetItem = Get-Item -Path $esdFullName -ErrorAction Stop

        if (! ($wimFullName)) {
            $wimFullName = Join-Path $esdGetItem.Directory ($esdGetItem.BaseName + '.wim')
        }
        
        if (Test-Path $wimFullName) {
            Write-Warning "Delete exiting WIM at $wimFullName"
            Break
        }
        else {
            try {
                New-Item -Path $wimFullName -Force -ErrorAction Stop | Out-Null
                Remove-Item -Path $wimFullName -Force -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Warning "New-Item failed $wimFullName"
                $wimFullName = $(Join-Path $env:TEMP $([string]$(Get-Random) + '.wim'))
            }
        }
        #=================================================
        #   Build
        #=================================================
        Write-Verbose -Verbose "ESD will be expanded to $wimFullName"
        $esdGetWindowsImage = Get-WindowsImage -ImagePath $esdGetItem.FullName -ErrorAction Stop
        foreach ($esdWindowsImage in $esdGetWindowsImage) {
            if ($esdWindowsImage.ImageName -eq 'Windows Setup Media') {
                Write-Verbose -Verbose "Skipping Index $($esdWindowsImage.ImageIndex) $($esdWindowsImage.ImageName)"
            } elseif ($esdWindowsImage.ImageName -like "*Windows PE*") {
                Write-Verbose -Verbose "Skipping Index $($esdWindowsImage.ImageIndex) $($esdWindowsImage.ImageName)"
            } elseif ($esdWindowsImage.ImageName -like "*Windows Setup*") {
                Write-Verbose -Verbose "Skipping Index $($esdWindowsImage.ImageIndex) $($esdWindowsImage.ImageName)"
            } else {
                Write-Verbose -Verbose "Exporting Index $($esdWindowsImage.ImageIndex) $($esdWindowsImage.ImageName)"
                Export-WindowsImage -SourceImagePath $esdGetItem.FullName -SourceIndex $($esdWindowsImage.ImageIndex) -DestinationImagePath $wimFullName -CompressionType Max -ErrorAction SilentlyContinue | Out-Null
            }
        }
        #=================================================
        #	Create ISO
        #=================================================
        Get-Item -Path $wimFullName
        #Get-WindowsImage -ImagePath $wimFullName
        #=================================================
    }
}
