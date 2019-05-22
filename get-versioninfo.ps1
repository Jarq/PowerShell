#The same path,different servers

function get-versioninfo {
[cmdletbinding()]
Param(
[parameter(mandatory=$true)]
[string]$path1

)
$servers="cscjarek22016",
"cscms702"

$foreach=foreach($server in $servers){
$item=(Get-Item $path) | select -First 5 | ForEach-Object{$_.Name,[System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion} 
#$item="$item".Split(",") 
$item | % {
$objproperties=@{
File=$_ 
Hostname=$server
} 
New-Object psobject -Property $objproperties  
}
}
$foreach | ConvertTo-Csv | Out-file c:\test.csv
}

#one server, different paths

function get-dllversion {
[cmdletbinding()]
Param(
[parameter(mandatory=$true)]
[string]$path1,
[string]$path2
)
$item1=(Get-Item $path1) | ForEach-Object{$_.Name,[System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion}
$item1
"`n`n`n"
$item2=(Get-Item $path2) | ForEach-Object{$_.Name,[System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion}
$item2
}