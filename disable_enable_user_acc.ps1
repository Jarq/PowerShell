$module=(Get-Module).Name
if ($module -notmatch 'ActiveDirectory') {
Import-Module ActiveDirectory
}

$menu= read-host -Prompt "
`n1. Disable Accounts
`n2. Enable Accounts
`n3. Exit
`nPlease Select a number"
switch($menu) {
    1{
    $whoami=$env:username
    $File=get-content "C:\Users\$whoami\Desktop\users.txt"
    foreach ($user in $File) {
    disable-ADAccount $user
    }}
    
    2{
    $whoami=$env:username
    $File=get-content "C:\Users\$whoami\Desktop\users.txt"
    foreach ($user in $File) {
    enable-ADAccount $user
    }}
    3{
    exit
    }}
    



