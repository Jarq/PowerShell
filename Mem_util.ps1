$TotalMem=[math]::Round((Get-WmiObject -Class Win32_ComputerSystem ).TotalPhysicalMemory /1MB)
$FreeMem=[math]::Round((Get-WmiObject -Class Win32_operatingsystem ).FreePhysicalMemory /1kb)
 
$result=$TotalMem - $FreeMem
$hname=hostname
 
Write-Output = "Memory usage on $hname is $result MB "   