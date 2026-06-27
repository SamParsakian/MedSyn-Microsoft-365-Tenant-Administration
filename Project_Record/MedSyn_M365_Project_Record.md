## MedSyn Microsoft 365 Admin Lab — Project Documentation

### Introduction

This document records the practical work completed during the Microsoft 365 tenant administration lab for Sam Medsyn Lab Company.

The work is documented in the same order it was completed. Scripts and reports are saved in the repository, and screenshots are used only where a visual result is useful for review.

Step 01 — Tenant Baseline Capture

The project starts from a short business scenario and two CSV files: one with company-level information and one with the planned user accounts. These files describe the departments, sites, and accounts that the Microsoft 365 tenant for Sam Medsyn Lab Company should eventually contain.

Before any configuration was made, the current state of the tenant was collected and saved. This follows common practice in real administration work, where the starting point of an environment is recorded before changes are introduced, so that later changes can be compared against a known baseline.

PowerShell was used for this step, together with the official Microsoft Graph, Exchange Online, and Microsoft Teams modules.

```powershell
# Required modules (installed once)
Install-Module Microsoft.Graph -Scope CurrentUser -Force
Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
Install-Module MicrosoftTeams -Scope CurrentUser -Force
```

```powershell
# Microsoft Graph: organization info, domains, users, licenses, groups, admin roles
Connect-MgGraph -Scopes "Organization.Read.All","Domain.Read.All","User.Read.All","Group.Read.All","RoleManagement.Read.Directory","Directory.Read.All","Sites.Read.All"

Get-MgOrganization | ConvertTo-Json -Depth 5 | Out-File "01_Organization.json"
Get-MgDomain | Export-Csv "02_AcceptedDomains.csv" -NoTypeInformation
Get-MgUser -All | Export-Csv "03_Users.csv" -NoTypeInformation
Get-MgSubscribedSku | Export-Csv "04_LicensesSubscriptions.csv" -NoTypeInformation
Get-MgGroup -All | Export-Csv "05_Groups.csv" -NoTypeInformation
# Directory role members are collected per role and saved to 06_AdminRoleAssignments.csv

Disconnect-MgGraph
```

```powershell
# Exchange Online: shared mailboxes and distribution lists
Connect-ExchangeOnline
Get-Mailbox -RecipientTypeDetails SharedMailbox | Export-Csv "07_SharedMailboxes.csv" -NoTypeInformation
Get-DistributionGroup | Export-Csv "08_DistributionLists.csv" -NoTypeInformation
Disconnect-ExchangeOnline -Confirm:$false
```

```powershell
# Microsoft Teams: current Teams list
Connect-MicrosoftTeams
Get-Team | Export-Csv "10_TeamsList.csv" -NoTypeInformation
Disconnect-MicrosoftTeams
```

The export confirmed that the tenant did not yet contain any of the SMLC departments, groups, shared mailboxes, distribution lists, or Teams described in the project scenario. This gives a clear, fresh starting point for the configuration steps that follow.

![Tenant baseline export terminal output](images/step01-tenant-export-terminal.png)
*Terminal output of the export script, showing each service connecting and each report being saved to the Reports folder.*

Chapter conclusion: The starting state of the tenant is now recorded in Reports/Tenant_Before_State. This baseline is ready to be used for comparison once the SMLC company structure is configured.
