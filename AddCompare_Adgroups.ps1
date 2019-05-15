$module=(Get-Module).Name
if ($module -notmatch 'ActiveDirectory') {
Import-Module ActiveDirectory
}
$user1=Read-Host "please provide main user logon name"
$member= Get-ADPrincipalGroupMembership $user1
$member=$member.name

$user2=Read-Host "please provide second user logon name to which you want add groups from $user1"
$member2= Get-ADPrincipalGroupMembership $user2
$member2=$member2.name
$compare=Compare-Object -ReferenceObject $member -DifferenceObject $member2
$menu= read-host -Prompt "
`n1. Show differences
`n2. Add missing groups
`n3. Exit
`nPlease Select a number"
switch($menu) {
    1{ 
        if($compare.InputObject -eq $null){
            Write-Output "Nothing to do here, both users have the same groups"
            }
            else{ Write-Output $compare }
    }
    2{
    if($compare.InputObject -eq $null){
            Write-Output "Nothing to do here, both users have the same groups"
            }
    $compareInput=$compare.InputObject
    
    $foreach=foreach($indicator in $compareInput){$indicator + "`n"}
    $SideIndicator = $compare.SideIndicator
    if($SideIndicator -eq "<="){
    $readhost=Read-Host "Following groups will be added from user $user1 to $user2 `n $foreach `n press [y] to continue"
        if($readhost -eq "y") {
            foreach($group in $compareInput) {
            Add-ADGroupMember -Identity $group -Members $user2
                if($SideIndicator -eq "=>"){exit}
            }
            }
       }
    if($SideIndicator -eq "=>") { Write-Output "Nothing to do here, user $user2 has all $user1 groups already added" }
        }
    3{
    exit
    }
    }
  