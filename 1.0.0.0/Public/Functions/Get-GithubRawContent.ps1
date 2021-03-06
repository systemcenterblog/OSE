function Get-GithubRawContent
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [System.Uri]
        # Github Url to retrieve
        $Uri
    )

    $GithubRawUrl = Get-GithubRawUrl -Uri $Uri
    #Write-Verbose $GithubRawUrl

    if ($GithubRawUrl)
    {
        foreach ($Item in $GithubRawUrl)
        {
            Write-Verbose $Item
            try
            {
                $WebRequest = Invoke-WebRequest -Uri $Item -UseBasicParsing -Method Head -ErrorAction SilentlyContinue
                if ($WebRequest.StatusCode -eq 200)
                {
                    Invoke-RestMethod -Uri $Item
                }
            }
            catch
            {
                Write-Warning $_
            }
        }
    }
}
