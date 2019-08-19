#users logged on the server during specified timerange

$hostname= read-host "Please specify server name which should be scanned"
if($hostname.Length -eq 0) {$hostname = $env:computername}

$start = read-host "Please provide start date according to your time zone i.e dd/mm/yyyy ( default 01/01/2019)"
if($start.Length -eq 0) {$start= "01/01/2019"}

$end = read-host "Please provide end date (default=current date)"
if($end.Length -eq 0) {$end = get-date}

#Successfull Logon
$eventlog=Get-Eventlog -LogName Security -ComputerName $hostname -after $start -before $end | where EventID -eq 4624 
foreach ($log in $EventLog){
    # Logon Successful Events
    # Local 
    if (($log.EventID -eq 4624 ) -and ($log.ReplacementStrings[8] -eq 2)){
      write-host "Type: Local Logon`tDate: "$log.TimeGenerated "`tStatus: Success`tUser: "$log.ReplacementStrings[5] "`tWorkstation: "$log.ReplacementStrings[11]
    }
    # Remote 
    if (($log.EventID -eq 4624 ) -and ($log.ReplacementStrings[8] -eq 10)){
      write-host "Type: Remote Logon`tDate: "$log.TimeGenerated "`tStatus: Success`tUser: "$log.ReplacementStrings[5] "`tWorkstation: "$log.ReplacementStrings[11] "`tIP Address: "$log.ReplacementStrings[18]
    }}
