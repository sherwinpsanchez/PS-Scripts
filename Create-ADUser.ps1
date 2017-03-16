Import-Module ActiveDirectory
New-ADUser `
 -Name "TestUser" `
 -Path  "OU=TestOU,DC=TestDomain,DC=Local" `
 -SamAccountName  "TestUser" `
 -DisplayName "Test User" `
 -AccountPassword (ConvertTo-SecureString "SecretPassword123" -AsPlainText -Force) `
 -ChangePasswordAtLogon $true  `
 -Enabled $true
Add-ADGroupMember "Domain Admins" "TestUser";