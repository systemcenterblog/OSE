function Get-GithubRawUrl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [System.Uri]
        # Github Url to retrieve
        $Uri
    )
    #Write-Warning 'GithubRaw functions are currently under development'
    #Write-Warning 'Functionality is subject to change until this warning is removed'

    if ($Uri -match 'gist.github.com')
    {
        try
        {
            $GetUri = (Invoke-WebRequest -UseBasicParsing -Method Get -Uri $Uri).Links | Where-Object {($_.outerHTML -match 'RAW') -and ($_.class -match 'btn-sm btn')} | Select-Object -ExpandProperty href
            $GetUri = $GetUri | ForEach-Object {"https://gist.githubusercontent.com$_" -replace '\/raw\/[\w-]{40}','/raw'}
            $GetUri
        }
        catch
        {
            Write-Warning $_
        }
    }
    elseif ($Uri -match 'github.com')
    {
        try
        {
            $GetUri = (Invoke-WebRequest -UseBasicParsing -Method Get -Uri $Uri).Links | Where-Object {($_.outerHTML -match 'RAW') -and ($_.class -match 'btn-sm btn')} | Select-Object -ExpandProperty href
            $GetUri = $GetUri -replace '/raw/','/'
            $GetUri = $GetUri | ForEach-Object {"https://raw.githubusercontent.com$_"}
            $GetUri
        }
        catch
        {
            Write-Warning $_
        }
    }
    elseif (([System.Uri]$Uri).AbsoluteUri) {
        ([System.Uri]$Uri).AbsoluteUri
    }
    else
    {
        [System.String]$Uri
    }
}
