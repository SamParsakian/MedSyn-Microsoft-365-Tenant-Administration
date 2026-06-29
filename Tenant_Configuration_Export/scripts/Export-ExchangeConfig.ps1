<#
.SYNOPSIS
    Extracts the current Exchange Online configuration from the SMLC tenant:
    mailboxes, distribution lists, shared mailbox permissions, mail flow rules,
    and the anti-spam / anti-malware / anti-phishing policy state.

.DESCRIPTION
    Read-only. Makes no changes to the tenant. Connects once and exports
    everything this script covers in a single Exchange Online session.

.NOTES
    Run after Export-Identity.ps1. Output is written to ../output/Exchange/
#>

$ErrorActionPreference = 'Continue'
$outputFolder = Join-Path $PSScriptRoot "..\output\Exchange"
New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null

Write-Host "Connecting to Exchange Online..."
Connect-ExchangeOnline -ShowBanner:$false

# --- Mailboxes ---
Get-Mailbox -ResultSize Unlimited |
    Select-Object DisplayName, PrimarySmtpAddress, RecipientTypeDetails, ForwardingSmtpAddress, ForwardingAddress |
    Export-Csv "$outputFolder/01_Mailboxes.csv" -NoTypeInformation -Encoding utf8

# --- Shared mailbox permissions ---
$sharedMailboxes = Get-Mailbox -ResultSize Unlimited -RecipientTypeDetails SharedMailbox
$permRows = foreach ($mbx in $sharedMailboxes) {
    $fullAccess = Get-MailboxPermission -Identity $mbx.PrimarySmtpAddress | Where-Object { $_.User -notlike "NT AUTHORITY*" -and -not $_.IsInherited }
    $sendAs = Get-RecipientPermission -Identity $mbx.PrimarySmtpAddress | Where-Object { $_.Trustee -notlike "NT AUTHORITY*" }
    [PSCustomObject]@{
        Mailbox        = $mbx.PrimarySmtpAddress
        FullAccessUsers = ($fullAccess.User -join ';')
        SendAsUsers     = ($sendAs.Trustee -join ';')
    }
}
$permRows | Export-Csv "$outputFolder/02_SharedMailboxPermissions.csv" -NoTypeInformation -Encoding utf8

# --- Distribution lists ---
Get-DistributionGroup -ResultSize Unlimited |
    Select-Object DisplayName, PrimarySmtpAddress, RequireSenderAuthenticationEnabled,
        @{N='AcceptMessagesOnlyFrom';E={$_.AcceptMessagesOnlyFromSendersOrMembers -join ';'}} |
    Export-Csv "$outputFolder/03_DistributionLists.csv" -NoTypeInformation -Encoding utf8

# --- Mail flow rules ---
Get-TransportRule | Select-Object Name, State, Priority, Mode, Comments |
    Export-Csv "$outputFolder/04_TransportRules.csv" -NoTypeInformation -Encoding utf8

# --- Anti-spam / anti-malware / anti-phishing / outbound spam (forwarding) ---
Get-HostedContentFilterPolicy -Identity Default | Select-Object Identity, SpamAction, HighConfidenceSpamAction |
    Export-Csv "$outputFolder/05_AntiSpamPolicy.csv" -NoTypeInformation -Encoding utf8
Get-MalwareFilterPolicy -Identity Default | Select-Object Identity, Action |
    Export-Csv "$outputFolder/06_AntiMalwarePolicy.csv" -NoTypeInformation -Encoding utf8
Get-AntiPhishPolicy -Identity "Office365 AntiPhish Default" | Select-Object Identity, Enabled |
    Export-Csv "$outputFolder/07_AntiPhishPolicy.csv" -NoTypeInformation -Encoding utf8
Get-HostedOutboundSpamFilterPolicy -Identity Default | Select-Object Identity, AutoForwardingMode |
    Export-Csv "$outputFolder/08_OutboundSpamPolicy.csv" -NoTypeInformation -Encoding utf8

Disconnect-ExchangeOnline -Confirm:$false | Out-Null
Write-Host "Exchange extraction complete. Files saved to $outputFolder"
