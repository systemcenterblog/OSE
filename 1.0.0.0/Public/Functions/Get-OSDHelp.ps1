function Get-OSDHelp {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]$RepoFolder,

        [Alias('OAuthToken')]
        [string]$OAuth
    )

    $RepoOwner = 'OSDeploy'
    $RepoName = 'OSDHelp'

    if ($OAuth) {
        $OSDPadParams = @{
            Brand           = "OSDHelp $RepoFolder"
            RepoOwner       = $RepoOwner
            RepoName        = $RepoName
            RepoFolder      = $RepoFolder
            OAuth           = $OAuth
        }
    }
    else {
        $OSDPadParams = @{
            Brand           = "OSDHelp $RepoFolder"
            RepoOwner       = $RepoOwner
            RepoName        = $RepoName
            RepoFolder      = $RepoFolder
        }
    }
    Get-OSDPad @OSDPadParams
}
