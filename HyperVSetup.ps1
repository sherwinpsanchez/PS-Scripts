#--------------------- 
# Title:        HyperVSetup.ps1 
# Author:       Sherwin Sanchez
#               
# Description:  Install Hyper-V Role and add Admin account
#               to Hyper-V Administrators group. Restarts
#               the Server.
# 
# Version 1.0 
# 
#--------------------- 

$group = [ADSI]"WinNT://edlt/mygroup,group"

Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
$group.Add("WinNT://edlt/Hyper-V Administrators,tstadm")
Restart-Computer -ComputerName newserver -Force