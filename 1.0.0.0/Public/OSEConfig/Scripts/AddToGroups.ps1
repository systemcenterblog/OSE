# Script to add the computername on which the script is executed on to specified groups
# Example Command line Powershell.exe -Set-ExecutionPolicy bypass -file .\Removefromgroup.ps1 ADgroup1:adgroup2:"AD group3"

$Groups = $args[0].Split(':')

foreach($Group in $Groups) {

    try {

        $ComputerDn = ([ADSISEARCHER]"sAMAccountName=$($env:COMPUTERNAME)$").FindOne().Path
        $GroupDn = ([ADSISEARCHER]"sAMAccountName=$($Group)").FindOne().Path
        $Group = [ADSI]"$GroupDn"

        if(!$Group.IsMember($ComputerDn)) {
            $Group.Add($ComputerDn)
        }
    }
    catch {
        $_.Exception.Message ; Exit 1
    }
}