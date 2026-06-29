<#
.SYNOPSIS
    Extracts the current identity and collaboration configuration from the SMLC tenant
    via Microsoft Graph: users, licenses, groups, admin roles, guests, Teams, and the
    key tenant-wide security policies.

.DESCRIPTION
    Read-only. Makes no changes to the tenant. Connects once and exports everything
    this script covers in a single Microsoft Graph session.

.NOTES
    Run this, then Export-ExchangeConfig.ps1, then Export-SharePointTenant.ps1.
    Output is written to ../output/Identity/
#>

$ErrorActionPreference = 'Continue'
$outputFolder = Join-Path $PSScriptRoot "..\output\Identity"
New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null

Write-Host "Connecting to Microsoft Graph..."
Connect-MgGraph -Scopes "User.Read.All","Group.Read.All","GroupMember.Read.All","Organization.Read.All",`
    "RoleManagement.Read.Directory","Directory.Read.All","Policy.Read.All","Team.ReadBasic.All",`
    "ServiceHealth.Read.All","ServiceMessage.Read.All" -UseDeviceCode -NoWelcome

# --- Users and licensing ---
Get-MgUser -All -Property DisplayName,UserPrincipalName,Department,JobTitle,AccountEnabled,UserType,UsageLocation |
    Select-Object DisplayName,UserPrincipalName,Department,JobTitle,AccountEnabled,UserType,UsageLocation |
    Export-Csv "$outputFolder/01_Users.csv" -NoTypeInformation -Encoding utf8

Get-MgSubscribedSku | Select-Object SkuPartNumber, SkuId, ConsumedUnits, @{N='Enabled';E={$_.PrepaidUnits.Enabled}} |
    Export-Csv "$outputFolder/02_Licenses.csv" -NoTypeInformation -Encoding utf8

# --- Groups and membership ---
$groups = Get-MgGroup -All -Property DisplayName,Mail,GroupTypes,SecurityEnabled,Id
$groups | Select-Object DisplayName, Mail, GroupTypes, SecurityEnabled |
    Export-Csv "$outputFolder/03_Groups.csv" -NoTypeInformation -Encoding utf8

$membershipRows = foreach ($g in $groups) {
    $members = Get-MgGroupMember -GroupId $g.Id -All
    [PSCustomObject]@{
        Group   = $g.DisplayName
        Members = ($members | ForEach-Object { (Get-MgUser -UserId $_.Id -Property UserPrincipalName -ErrorAction SilentlyContinue).UserPrincipalName }) -join ';'
    }
}
$membershipRows | Export-Csv "$outputFolder/04_GroupMembership.csv" -NoTypeInformation -Encoding utf8

# --- Admin roles and guests ---
Get-MgDirectoryRole -All | ForEach-Object {
    $role = $_
    Get-MgDirectoryRoleMember -DirectoryRoleId $role.Id | ForEach-Object {
        [PSCustomObject]@{ Role = $role.DisplayName; Member = (Get-MgUser -UserId $_.Id -ErrorAction SilentlyContinue).UserPrincipalName }
    }
} | Export-Csv "$outputFolder/05_AdminRoleAssignments.csv" -NoTypeInformation -Encoding utf8

Get-MgUser -Filter "userType eq 'Guest'" -All | Select-Object DisplayName, Mail, UserPrincipalName |
    Export-Csv "$outputFolder/06_GuestUsers.csv" -NoTypeInformation -Encoding utf8

# --- Teams ---
Get-MgGroup -Filter "resourceProvisioningOptions/Any(x:x eq 'Team')" -All |
    Select-Object DisplayName, Mail, Id |
    Export-Csv "$outputFolder/07_Teams.csv" -NoTypeInformation -Encoding utf8

# --- Tenant-wide security policy ---
$secDefaults = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy
$authPolicy = Get-MgPolicyAuthorizationPolicy
$caPolicies = Get-MgIdentityConditionalAccessPolicy -All
[PSCustomObject]@{
    SecurityDefaultsEnabled = $secDefaults.IsEnabled
    AllowInvitesFrom        = $authPolicy.AllowInvitesFrom
    ConditionalAccessPolicyCount = $caPolicies.Count
} | Export-Csv "$outputFolder/08_TenantSecurityPolicy.csv" -NoTypeInformation -Encoding utf8

# --- Service health and message center ---
Get-MgServiceAnnouncementHealthOverview | Export-Csv "$outputFolder/09_ServiceHealth.csv" -NoTypeInformation -Encoding utf8
Get-MgServiceAnnouncementMessage -Top 25 | Select-Object Title, Services, LastModifiedDateTime |
    Export-Csv "$outputFolder/10_MessageCenterRecent.csv" -NoTypeInformation -Encoding utf8

Disconnect-MgGraph | Out-Null
Write-Host "Identity extraction complete. Files saved to $outputFolder"
