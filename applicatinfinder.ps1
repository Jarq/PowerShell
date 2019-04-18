
#Uncomment line below if you want to check all servers in the domain
#$list=Get-ADComputer -Filter "*" | ?{$_.Enabled -eq $TRUE} |  select name -first 3

#Uncomment line below if you want to provide list of server manually into the script 
#$list="cscjarekm5.csclab.local", "cscjarekm6.csclab.local"

#uncomment line below if you want to provide path to the file
#$list= Get-Content -Path "PATH TO THE FILE"

$name = Read-Host "Please provide application name"

foreach ($computer in $list)
{
    trap{"$computer`: not reachable";break}
    if(test-wsman -ComputerName $computer -ea stop){
        $gcim=gcim -Class CIM_Product -Filter "Name like '$name'" |
            select  -First 2
        
       
        
    }
        $app=$gcim.name 
        $app.split(',') | % {
            $objproperties =@{
            Application = $_
            Hostname = $computer
            }
            New-Object psobject -Property $objproperties
           

}
}
