

$hostname=read-host "Please Specify hostname where you want to look at iis configuration"
$pssession=New-PSSession -ComputerName $hostname -Credential $env:credential
Invoke-Command -Session $pssession -ScriptBlock{

$module=(Get-Module).Name
if ($module -notmatch 'WebAdministration') {
Import-Module WebAdministration
}

$defweb=Read-Host "Please Specify your Default web Site name: "
$var=Get-WebConfigurationProperty -filter /system.web/httpRuntime -name ExecutionTimeout -PSPath "IIS:\Sites\Default Web Site\$defweb" | select Name, Value

$var1=Get-WebConfigurationProperty -filter /system.web/httpRuntime -name MaxRequestLength -PSPath "IIS:\Sites\Default Web Site\$defweb" | select Name, Value

#$var 
#$var1

}

$hash=@{
ExecutionTimeout = $var.value
MaxRequestLength = $var1.value
}
$object = New-Object psobject -Property $hash
$object | Format-List
Exit-PSSession
