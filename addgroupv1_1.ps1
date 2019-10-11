<#
.SYNOPSIS
  The main function of this script is to ADD group to specified OU and grant permission to given file/folder path
.DESCRIPTION
  The fucntion looks for DC and connects to it, after connected it's trying to find the customer's ou and add  pointed group.
  After that it's going back to your localhost and it's granting permissions (depends of what you choose) into the given folder location.
.OUTPUTS
  N/A
.NOTES
  Version:        1.1
  Author:         Jaroslaw Zadlok
  Creation Date:  09.10.2019
  Purpose/Change: Automate manual work
  
.EXAMPLE
  ADD-adgroup -customer eco -Environment acpt -group "gg-write3" -folderPath "C:\testfolder\testfolder" -allow Allow -Accesstype 'FullControl'
#>


Function ADD-adgroup {
param (
[parameter(mandatory=$true)]
[string]$customer,

[parameter(mandatory=$true)]
[string]$Environment,

[parameter(mandatory=$true)]
[string]$group,

[parameter(mandatory=$true)]
[string]$folderPath,

[parameter()]
[ValidateSet('read','write','FullControl','Modify','ReadAndExecute')]
[string]$Accesstype,

[parameter()]
[ValidateSet('Allow','Deny')]
[string]$allow
)

Set-Variable -Name $group -Option AllScope

#connecting to the DC

$netdom=netdom query dc
$netdom[2]

Invoke-Command -ComputerName $netdom[2] -ScriptBlock{$customer=$args[0];$Environment=$args[1];$group=$args[2]

$createdGroup= Get-ADGroup -Filter "*" | ?{$_.DistinguishedName -like "*$Environment*" -and $_.Name -like "$group"} 
$bool=$group.equals($createdGroup.name)
#checking if provided group is already created
    if($bool -eq $true){
        Write-Host "Group $group has already been created" -ForegroundColor Green
}
    else{
        $ou=(Get-ADOrganizationalUnit -Filter 'Name -like "*"'|?{$_.Name -like "*$customer*"}).distinguishedName #| ?{$_.DistinguishedName -like "*Customer Resources*"}).DistinguishedName 
        $env=Get-ADOrganizationalUnit -Filter 'Name -like "*"' -searchbase $ou  | ?{$_.Name -like "$Environment"} 
        $envdist=$env.DistinguishedName
        #creating AD group
        New-ADGroup -Path $envdist -Name $group -GroupScope Global -GroupCategory Security
        $createdGroup= Get-ADGroup -Filter "*" | ?{$_.DistinguishedName -like "*$Environment*" -and $_.Name -like "$group"}
        if($group.equals($createdGroup.name) -eq $true){
         
        Write-Host "Group $group has been added" -ForegroundColor Green }
        
            }

} -ArgumentList $customer,$Environment,$group

#granting necessary permissions

$acl = get-acl $folderpath
$accessrule= New-Object System.Security.AccessControl.FileSystemAccessRule("csclab\$group",$Accesstype,$allow)
$acl.SetAccessRule($accessrule)
$acl | set-acl -Path $folderpath
$gacl= get-acl -Path $folderPath
if($gacl.Access.IdentityReference -like "*$group*" -and $gacl.Access.FileSystemRights -like "*$accesstype*"){
Write-Host "Group "$group" has been successfully assigned to "$folderPath"" -ForegroundColor Green
}
else { Write-Host "Something went wrong, Group "$group" has NOT been successfully assigned to "$folderPath"" -ForegroundColor Red}
}
 

