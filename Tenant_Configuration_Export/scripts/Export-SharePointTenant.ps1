<#
.SYNOPSIS
    Extracts the current SharePoint site list and tenant-level sharing settings
    from the SMLC tenant.

.DESCRIPTION
    Read-only. Makes no changes to the tenant. Uses the SharePoint admin
    connection, which only needs to sign in once for tenant-wide site
    properties (this does not cover per-site Owners/Members/Visitors -
    see browser-console-export-sharepoint-permissions.js for that part,
    which uses a signed-in SharePoint browser session for site-level
    permission groups).

.NOTES
    Run after Export-ExchangeConfig.ps1. Output is written to ../output/SharePoint/
    Requires the SharePoint Online Management Shell app ID for PnP.PowerShell v3+.
#>

$ErrorActionPreference = 'Continue'
$outputFolder = Join-Path $PSScriptRoot "..\output\SharePoint"
New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null
$clientId = "9bc3ab49-b65d-410a-85ad-de819febfddc"   # SharePoint Online Management Shell app ID

Write-Host "Connecting to SharePoint tenant admin..."
Connect-PnPOnline -Url "https://samstack-admin.sharepoint.com" -DeviceLogin -ClientId $clientId

Get-PnPTenantSite | Select-Object Title, Url, Template, StorageUsageCurrent, SharingCapability |
    Export-Csv "$outputFolder/01_SiteList.csv" -NoTypeInformation -Encoding utf8

Disconnect-PnPOnline
Write-Host "SharePoint tenant extraction complete. Files saved to $outputFolder"
Write-Host "Next: run browser-console-export-sharepoint-permissions.js in your browser for per-site permissions."
