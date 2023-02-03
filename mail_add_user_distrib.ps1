Import-Module ActiveDirectory

$condition = $args[0]
$username = $args[1]
$groupname = $args[2]


switch ( $condition )
{
    Add
    {
        if ( !(Get-ADGroupMember -Identity $groupname | Where-Object {$_.name -eq $username}) )
        {
            write-host ""
            write-host "Ajout de l'utilisateur $username dans le groupe $groupname"
            Add-ADGroupMember -Identity $groupname -Members $username
            $err_rtn=$?
            if ($err_rtn -ne $True)
            {
                write-host ""
                $log_text="Failed to add user $username in group $groupname !"
                echo `r($log_text).ToUpper() | Write-Host -ForegroundColor "red" -BackgroundColor "black"
            }   
        }
        else
        {
            write-host ""
            write-host "can't add, user $username already in group $groupname"
        }
    }
    Delete
    {
        if ( Get-ADGroupMember -Identity $groupname | Where-Object {$_.name -eq $username} )
        {
            write-host ""
            write-host "Suppression de l'utilisateur $username du groupe $groupname"
            Remove-ADGroupMember -Identity $groupname -Members $username -Confirm:$False
            $err_rtn=$?
            if ($err_rtn -ne $True)
            {
                write-host ""
                $log_text="Failed to delete user $username from group $groupname !"
                echo `r($log_text).ToUpper() | Write-Host -ForegroundColor "red" -BackgroundColor "black"
            }
        }
        else
        {
            write-host ""
            write-host "can't delete, user $username not in group $groupname"
        }
    }
}
