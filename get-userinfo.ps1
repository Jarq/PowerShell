function get-userinfo {
param (
[parameter(mandatory=$true)]
[string]$OutputPath
)  
$path=(Get-ADUser -Filter *).SamAccountName 
#$path=get-content $inputpath
$f=foreach ($user in $path) {
    $groups=(Get-ADPrincipalGroupMembership $user).name
    $account=(Get-ADUser $user).enabled
    $name=(get-aduser $user).name
    
    $groups.Split(",") | % {
     $description=(Get-ADGroup $_ -Properties *).description
        $objproperties = @{
            Group = $_
            Name=$name
            User = $user  
            Enabled = $account
            Description = $description
        }
         New-Object psobject -Property $objproperties 
    }
    
}

$f | ConvertTo-csv | Out-File $OutputPath
}