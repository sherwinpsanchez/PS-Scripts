#--------------------- 
# Title:        CreateLA.ps1 
# Author:       Sherwin Sanchez
#               
# Description:  Create a Local Admin User on a new Local/Hyper-V Server and
#               add it to: Administrators, Remote Desktop Users, 
#               Remote Management Users
# 
# Version 1.0 
# 
#--------------------- 
 
param([string]$UserName, [string]$FullName, [string]$Password, [switch]$Add, [switch]$Remove, [switch]$ResetPassword, [switch]$help, [string]$computername)  
$group = [ADSI]"WinNT://edlt/mygroup,group"

function AddRemove-LocalAccount ([string]$UserName, [string]$FullName, [string]$Password, [switch]$Add, [switch]$Remove, [switch]$ResetPassword, [string]$computerName) { 
    if($Add) { 
        [string]$ConnectionString = "WinNT://$computerName,computer" 
        $ADSI = [adsi]$ConnectionString 
        $User = $ADSI.Create("user",$UserName) 
        $User.SetPassword($Password) 
        echo "-------------DEBUGGING---------------" 
        Echo "Connection String:  $connectionstring" 
        echo "Username:           $username" 
        #echo "Password:           $password" 
        echo "-------------------------------------" 
    $User.SetInfo() 
     
    ([ADSI]"WinNT://$computerName/Administrators,group").Add("WinNT://$UserName") 
    $user.put("Description","IDI User Account") 
    $user.setInfo() 
    $user.put("FullName",$FullName)  
    $user.Put("PasswordExpired", 1) 
    $user.SetInfo() 
    } 
 
    if($Remove) { 
        [string]$ConnectionString = "WinNT://$computerName,computer" 
        $ADSI = [adsi]$ConnectionString 
        $ADSI.Delete("user",$UserName) 
    } 
 
    if($ResetPassword) { 
        [string]$ConnectionString = "WinNT://" + $ComputerName + "/" + $UserName + ",user" 
        $Account = [adsi]$ConnectionString 
        $Account.psbase.invoke("SetPassword", $Password) 
    } 
} 
 
if($help) { GetHelp; Continue } 
if($UserName -AND $Password -AND $Add -AND !$ResetPassword -and !$FullName) { AddRemove-LocalAccount -UserName $UserName -Password $Password -Add -computerName $computerName} 
if($UserName -AND $FullName -AND $Password -AND $Add -AND !$ResetPassword) { AddRemove-LocalAccount -UserName $UserName -FullName $FullName -Password $Password -Add -computerName $computerName} 
if($UserName -AND $Password -AND $ResetPassword) { AddRemove-LocalAccount -UserName $UserName -Password $Password -ResetPassword -computerName $computerName} 
if($UserName -AND $Remove) { AddRemove-LocalAccount -UserName $UserName -Remove -computerName $computerName}

-Username tstadm -Password Schm@i@hx00 -ResetPassword -add -computername newserver
.\Get-Set-ADAccountasLocalAdministrator.ps1 -Computer newserver -Trustee tstadm
$group.Add("WinNT://edlt/Remote Desktop Users,tstadm")
$group.Add("WinNT://edlt/Remote Management Users,tstadm")