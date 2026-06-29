# Business Scenario: Sam Medsyn Lab Company Microsoft 365 Admin Lab

## 1. Scenario Overview

The Microsoft 365 administrator is responsible for configuring the tenant for **Sam Medsyn Lab Company AB**, also called **SMLC**.

SMLC is a fictional small-to-mid-size technical support company in Sweden. The company supports medical imaging centers, including MRI, CT, and X-ray clinics. Its work includes software support, remote support, field support, maintenance, customer service, sales, finance, HR, and internal IT operations.

The company already has a network design with one headquarters site and one branch site. The Microsoft 365 tenant must follow the same business structure, departments, locations, naming standards, and security requirements.

![SMLC network design](images/smlc-network-design.jpg)
_Network design for Sam Medsyn Lab Company, showing the headquarters and branch structure that this Microsoft 365 tenant should follow._

The required outcome is a configured and documented Microsoft 365 tenant that supports SMLC's operations, collaboration, identity management, and baseline security controls.

## 2. Provided Source Files

The following CSV files are provided with this scenario:

| File | Purpose |
|---|---|
| `SMLC_company_master_data.csv` | Company, department, location, contact, group, mailbox, and sensitivity information |
| `SMLC_people_master_data.csv` | Staff, admin-only, break-glass, and guest account data |

Use these CSV files as the source of truth for users, groups, departments, locations, and access assignments.

## 3. Main Project Goal

Build a secure Microsoft 365 environment for SMLC.

The environment must support:

- company email
- department-based collaboration
- Microsoft Teams communication
- SharePoint document storage
- OneDrive personal storage
- secure admin access
- controlled external sharing
- basic compliance planning
- onboarding and offboarding
- cloud identity management
- HQ and branch access separation
- permission review
- service health monitoring
- basic incident response documentation

Most configuration should be completed with PowerShell where possible. The Microsoft 365 admin portals may be used for verification, screenshots, license checks, Service Health, Message Center, and settings that are easier to confirm visually.

## 4. Company Identity

| Item | Value |
|---|---|
| Company name | Sam Medsyn Lab Company AB |
| Short name | SMLC |
| Legal type | Aktiebolag (AB) |
| Organization number | 559382-1047 |
| VAT number | SE559382104701 |
| Industry | Medical imaging IT support and field services |
| Website | `https://www.sammedsynlab.com` |
| Country | Sweden |
| Currency | SEK |
| Time zone | Europe/Stockholm |
| Default language | English |

## 5. Tenant and Domain Information

| Item | Planned Value |
|---|---|
| Project name | MedSyn Microsoft 365 Admin Lab |
| Suggested tenant name | `smlcmedsyn.onmicrosoft.com` |
| Suggested public domain | `sammedsynlab.com` |
| Primary email format | `firstname.lastname@sammedsynlab.com` |
| Fallback email format | `firstname.lastname@smlcmedsyn.onmicrosoft.com` |

If the custom public domain is not available, use the default Microsoft 365 tenant domain.

The administrator should try to add and verify the custom domain if it is available. If it is not available, document that limitation and continue with the available tenant domain.

## 6. Company Locations

The Microsoft 365 setup must match the company site structure.

| Site Code | Site Name | City | Region | Address | Main Phone |
|---|---|---|---|---|---|
| SMLC-HQ | Headquarters | Nacka | Stockholm County | Radiovägen 12, 131 54 Nacka | +46 8 555 0100 |
| SMLC-BR | Branch Office | Malmö | Skåne County | Medicinteknikgatan 7, 211 20 Malmö | +46 40 555 0200 |

Use these values for the **Office Location** attribute:

- `SMLC-HQ`
- `SMLC-BR`

## 7. Department Structure

The company has five main Microsoft 365 departments and two branch subgroups.

| Department | Description | Primary Site | Cost Center | Data Sensitivity |
|---|---|---|---|---|
| MgmtAdmin | Management, administration, HR | HQ | ADM-100 | High |
| ITInfra | IT, network, systems, security | HQ | IT-100 | High |
| TechOps | Technical support and field support | HQ/BR | TOPS-100 | Internal |
| BizOps | Sales, marketing, customer service | HQ/BR | BIZ-100 | Internal |
| Finance | Accounting, payroll, invoices | HQ | FIN-100 | High |
| FieldOps | Branch field engineers | BR | FLD-100 | Internal |
| Support | Branch support desk | BR | SUP-100 | Internal |

For Microsoft 365 design, the five main departments are:

1. MgmtAdmin
2. ITInfra
3. TechOps
4. BizOps
5. Finance

FieldOps and Support are used as branch-related subgroups under the wider technical support model.

## 8. User Count

| Account Type | Count | Notes |
|---|---:|---|
| Staff users | 48 | Normal business users |
| Guest users | 2 | External test users |
| Admin-only accounts | 8 | Separate privileged accounts |
| Break-glass accounts | 2 | Emergency tenant recovery accounts |
| Total accounts in people CSV | 60 | Includes staff, guests, admins, and break-glass accounts |

Admin-only accounts must not be used as daily work accounts.

Break-glass accounts are only for emergency tenant recovery.

## 9. Staff Split by Site

| Site | Staff Count |
|---|---:|
| HQ | 37 |
| Branch | 11 |
| Total | 48 |

### HQ Staff

| Department | Count |
|---|---:|
| MgmtAdmin | 7 |
| ITInfra | 6 |
| Finance | 3 |
| BizOps | 5 |
| TechOps | 16 |
| Total HQ | 37 |

### Branch Staff

| Department or Subgroup | Count |
|---|---:|
| Branch TechOps | 3 |
| Branch FieldOps | 4 |
| Branch BizOps | 2 |
| Branch Support | 2 |
| Total Branch | 11 |

## 10. Naming Standards

Use clear and consistent names across Microsoft 365.

### Microsoft 365 Object Naming

Use this style:

`SMLC-[Department]-[ObjectType]-[Number]`

Examples:

- `SMLC-MgmtAdmin-User01`
- `SMLC-TechOps-Team`
- `SMLC-Finance-SharePoint`
- `SMLC-ITInfra-Admins`
- `SMLC-BizOps-SharedMailbox`

### Device Naming

Use this style for device-related planning:

`SMLC-[SITE]-[DEPT]-[TYPE][NUMBER]`

Examples:

- `SMLC-HQ-MgmtAdmin-PC01`
- `SMLC-HQ-TechOps-LAP01`
- `SMLC-HQ-ITInfra-ADM01`
- `SMLC-BR-TechOps-LAP01`
- `SMLC-BR-FieldOps-LAP01`

## 11. User Naming Standards

| Attribute | Standard |
|---|---|
| Username | `firstname.lastname@sammedsynlab.com` |
| Display name | First Last |
| User principal name | Same as username |
| Usage location | SE |
| Company name | Sam Medsyn Lab Company AB |
| MFA required | Yes |
| Account enabled | Yes, unless the account is being tested for offboarding or incident response |

Allowed department values:

- MgmtAdmin
- ITInfra
- Finance
- BizOps
- TechOps
- FieldOps
- Support

Allowed office location values:

- SMLC-HQ
- SMLC-BR
- External

## 12. Staff Account Plan

The full list of users is in `SMLC_people_master_data.csv`. The summary below explains the account design.

### MgmtAdmin - HQ - 7 Users

| User | Job Title |
|---|---|
| `owner@sammedsynlab.com` | Managing Director |
| `operations.manager@sammedsynlab.com` | Operations Manager |
| `admin.one@sammedsynlab.com` | Office Administrator |
| `admin.two@sammedsynlab.com` | Office Administrator |
| `hr.one@sammedsynlab.com` | HR Coordinator |
| `hr.two@sammedsynlab.com` | HR Coordinator |
| `executive.assistant@sammedsynlab.com` | Executive Assistant |

### Finance - HQ - 3 Users

| User | Job Title |
|---|---|
| `finance.manager@sammedsynlab.com` | Finance Manager |
| `accountant@sammedsynlab.com` | Accountant |
| `finance.assistant@sammedsynlab.com` | Finance Assistant |

### ITInfra - HQ - 6 Users

| User | Job Title |
|---|---|
| `it.manager@sammedsynlab.com` | IT Manager |
| `netadmin01@sammedsynlab.com` | Network Administrator |
| `netadmin02@sammedsynlab.com` | Network Administrator |
| `sysadmin01@sammedsynlab.com` | Systems Administrator |
| `sysadmin02@sammedsynlab.com` | Systems Administrator |
| `security.admin@sammedsynlab.com` | Security Administrator |

### BizOps - HQ - 5 Users

| User | Job Title |
|---|---|
| `sales.manager@sammedsynlab.com` | Sales Manager |
| `sales.one@sammedsynlab.com` | Sales Executive |
| `sales.two@sammedsynlab.com` | Sales Executive |
| `marketing.one@sammedsynlab.com` | Marketing Coordinator |
| `customer.service.one@sammedsynlab.com` | Customer Service Representative |

### TechOps - HQ - 16 Users

| User Pattern | Count | Job Title |
|---|---:|---|
| `techops.manager@sammedsynlab.com` | 1 | Technical Operations Manager |
| `software.support01-08@sammedsynlab.com` | 8 | Software Support Engineer |
| `field.engineer01-04@sammedsynlab.com` | 4 | Field Support Engineer |
| `helpdesk01-03@sammedsynlab.com` | 3 | Help Desk Technician |

### Branch - 11 Users

| User Pattern | Count | Department |
|---|---:|---|
| `br.techops01-03@sammedsynlab.com` | 3 | TechOps |
| `br.fieldops01-04@sammedsynlab.com` | 4 | FieldOps |
| `br.bizops01-02@sammedsynlab.com` | 2 | BizOps |
| `br.support01-02@sammedsynlab.com` | 2 | Support |

## 13. Admin Account Design

Normal users must not use their daily accounts for admin work. Create separate admin accounts for privileged tasks.

| Daily Account | Admin Account | Planned Role |
|---|---|---|
| `it.manager@sammedsynlab.com` | `adm-it.manager@sammedsynlab.com` | Privileged Role Administrator or Global Administrator |
| `netadmin01@sammedsynlab.com` | `adm-netadmin01@sammedsynlab.com` | Intune Administrator, if available |
| `netadmin02@sammedsynlab.com` | `adm-netadmin02@sammedsynlab.com` | Exchange Administrator |
| `sysadmin01@sammedsynlab.com` | `adm-sysadmin01@sammedsynlab.com` | SharePoint Administrator |
| `sysadmin02@sammedsynlab.com` | `adm-sysadmin02@sammedsynlab.com` | Teams Administrator |
| `security.admin@sammedsynlab.com` | `adm-security.admin@sammedsynlab.com` | Security Administrator |
| `helpdesk01@sammedsynlab.com` | `adm-helpdesk01@sammedsynlab.com` | Helpdesk Administrator or Password Administrator |
| Backup cloud admin | `adm-cloudadmin01@sammedsynlab.com` | Global Reader / Backup Cloud Administrator |

Create two emergency accounts:

| Account | Purpose |
|---|---|
| `breakglass01@sammedsynlab.com` | Emergency Global Administrator |
| `breakglass02@sammedsynlab.com` | Emergency Global Administrator |

Use least privilege. If a role or feature is not available with the current license, document it as a planned improvement.

## 14. Microsoft 365 Groups

Create these Microsoft 365 groups.

| Group | Purpose |
|---|---|
| SMLC-All-Staff | All licensed staff |
| SMLC-HQ-Staff | HQ users |
| SMLC-BR-Staff | Branch users |
| SMLC-MgmtAdmin | Management, admin, and HR |
| SMLC-ITInfra | IT and security users |
| SMLC-TechOps | Technical operations users |
| SMLC-BizOps | Sales, marketing, and customer service |
| SMLC-Finance | Finance users |
| SMLC-FieldOps | Branch field engineers |
| SMLC-Support | Support users |
| SMLC-HelpDesk | Help desk users |
| SMLC-Admins | Microsoft 365 admin accounts |
| SMLC-External-Guests | Approved external guests |

## 15. Security Groups

Create separate security groups for access control.

| Security Group | Purpose |
|---|---|
| SG-SMLC-M365-Admins | All admin-only and break-glass accounts |
| SG-SMLC-HQ-Staff | HQ access control |
| SG-SMLC-BR-Staff | Branch access control |
| SG-SMLC-Finance-Private | Finance-only access |
| SG-SMLC-HR-Private | HR-only access |
| SG-SMLC-ITInfra-Private | IT-only access |
| SG-SMLC-TechOps-Tools | Support tools and technical files |
| SG-SMLC-FieldOps-RemoteAccess | Field engineer resources |
| SG-SMLC-SharePoint-Owners | SharePoint owners |
| SG-SMLC-Guest-Restricted | Restricted guest access |

## 16. Distribution Lists

Create these distribution lists.

| List | Email |
|---|---|
| All Staff | `allstaff@sammedsynlab.com` |
| Management | `management@sammedsynlab.com` |
| HR | `hr@sammedsynlab.com` |
| Finance | `finance@sammedsynlab.com` |
| Sales | `sales@sammedsynlab.com` |
| Support | `support@sammedsynlab.com` |
| Help Desk | `helpdesk@sammedsynlab.com` |
| IT | `it@sammedsynlab.com` |
| Security | `security@sammedsynlab.com` |
| Branch Staff | `branch@sammedsynlab.com` |

Restrict senders for sensitive distribution lists:

- All Staff
- Management
- HR
- Finance
- Security

Only approved internal senders or the management group should be allowed to send to sensitive lists.

## 17. Shared Mailboxes

Create these shared mailboxes.

| Shared Mailbox | Email | Members |
|---|---|---|
| General Info | `info@sammedsynlab.com` | MgmtAdmin |
| Support | `support@sammedsynlab.com` | TechOps, Support |
| Help Desk | `helpdesk@sammedsynlab.com` | HelpDesk |
| Sales | `sales@sammedsynlab.com` | BizOps |
| Finance | `finance@sammedsynlab.com` | Finance |
| HR | `hr@sammedsynlab.com` | HR users |
| IT Support | `itsupport@sammedsynlab.com` | ITInfra |
| Security Alerts | `security@sammedsynlab.com` | Security Admin, IT Manager |
| No Reply | `noreply@sammedsynlab.com` | ITInfra only |

Give the correct users Full Access and Send As rights where needed.

## 18. Microsoft Teams Structure

Create these Teams.

| Team | Members |
|---|---|
| SMLC - HQ | HQ staff |
| SMLC - Branch | Branch staff |
| SMLC - MgmtAdmin | MgmtAdmin |
| SMLC - ITInfra | ITInfra |
| SMLC - TechOps | TechOps, FieldOps, Support |
| SMLC - BizOps | BizOps |
| SMLC - Finance | Finance |
| SMLC - Knowledge Base | All staff read; TechOps and ITInfra edit |

### Team Channels

| Team | Channels |
|---|---|
| SMLC - HQ | General, Announcements, Company Policies, Forms, Templates |
| SMLC - Branch | General, Branch Operations, Field Visits, Customer Issues, Branch Reports |
| SMLC - MgmtAdmin | General, Company Planning, HR Internal, Policies, Announcements |
| SMLC - ITInfra | General, Network, Servers, Microsoft 365 Admin, Security, Backup, Monitoring, Change Requests |
| SMLC - TechOps | General, Software Support, Field Support, Help Desk, Customer Issues, Knowledge Base, Escalations |
| SMLC - BizOps | General, Sales Leads, Marketing, Customer Requests, Reports |
| SMLC - Finance | General, Invoices, Expenses, Payroll, Compliance |

Finance and HR channels should be private or separated with strict permissions.

## 19. SharePoint Sites

Create or confirm these SharePoint sites.

| Site | Purpose |
|---|---|
| SMLC-HQ | Main HQ company site |
| SMLC-Branch | Branch office site |
| SMLC-MgmtAdmin | Management, admin, and HR documents |
| SMLC-ITInfra | IT documentation |
| SMLC-TechOps | Support and technical documents |
| SMLC-BizOps | Sales, customer service, and marketing |
| SMLC-Finance | Finance documents |
| SMLC-KnowledgeBase | Internal technical knowledge base |
| SMLC-Policies | Company policies |
| SMLC-Templates | Company templates and forms |

## 20. SharePoint Permission Model

Use group-based permissions only. Avoid assigning permissions directly to individual users unless there is a clear reason.

| Site | Owners | Members | Visitors |
|---|---|---|---|
| SMLC-HQ | MgmtAdmin, ITInfra | HQ Staff | Branch read optional |
| SMLC-Branch | Branch Manager, ITInfra | BR Staff | MgmtAdmin read |
| SMLC-MgmtAdmin | MgmtAdmin managers | MgmtAdmin | No general access |
| SMLC-ITInfra | IT Manager | ITInfra | No general access |
| SMLC-TechOps | TechOps Manager | TechOps, FieldOps, Support | ITInfra read/admin |
| SMLC-BizOps | Sales Manager | BizOps | MgmtAdmin read |
| SMLC-Finance | Finance Manager | Finance | No general access |
| SMLC-KnowledgeBase | TechOps, ITInfra | All staff read | No guests |
| SMLC-Policies | MgmtAdmin | All staff read | No guests |
| SMLC-Templates | MgmtAdmin | All staff read | No guests |

## 21. SharePoint Folder Structure

Create the following folders in the correct SharePoint sites.

| Site | Folders |
|---|---|
| SMLC-HQ | Announcements, Company Policies, Templates, Forms, General Documents |
| SMLC-Branch | Branch Operations, Field Visits, Customer Notes, Branch Reports, Local Procedures |
| SMLC-MgmtAdmin | HR Records, Employee Documents, Contracts, Internal Policies, Management Reports |
| SMLC-ITInfra | Network Documentation, Firewall Rules, Microsoft 365 Admin, Server Documentation, Backup Records, Security Incidents, Change Logs |
| SMLC-TechOps | Support Procedures, Software Packages, Customer Notes, Field Reports, Troubleshooting Guides, Escalations |
| SMLC-BizOps | Sales Leads, Marketing, Customer Requests, Reports, Customer Documents |
| SMLC-Finance | Invoices, Payroll, Expenses, Tax, Reports, Vendor Payments |
| SMLC-KnowledgeBase | Support Guides, Troubleshooting, Known Issues, Internal Procedures |
| SMLC-Policies | Company Policies, Security Policies, HR Policies, IT Policies |
| SMLC-Templates | Forms, Letter Templates, Report Templates, Customer Templates |

## 22. OneDrive Rules

Each licensed user should receive OneDrive storage.

Rules:

- Personal work files go to OneDrive.
- Department files go to SharePoint.
- Finance and HR files must not be shared publicly.
- External sharing should be restricted.
- Users must not use personal accounts for company files.

## 23. External Sharing and Guest Rules

External sharing must be controlled.

| Area | External Sharing Rule |
|---|---|
| Finance | Disabled |
| HR | Disabled |
| ITInfra | Disabled except admin approval |
| TechOps | Allowed for support cases with expiration |
| BizOps | Allowed with manager approval |
| Branch | Limited |
| Knowledge Base | Internal only |
| Policies | Internal only |

Create two guest users for testing:

| Guest | Purpose |
|---|---|
| `vendor.tech@example.com` | External vendor contact for TechOps |
| `clinic.contact@example.com` | External clinic contact for BizOps |

Guest rules:

- Guests cannot access Finance.
- Guests cannot access HR.
- Guests cannot access ITInfra.
- Guests can access only approved TechOps or BizOps areas.
- Guest access should expire or be reviewed.
- Guest access must be documented.

## 24. Exchange Online Requirements

Configure or verify:

- accepted domain
- user mailboxes
- shared mailboxes
- distribution lists
- restricted senders for sensitive lists
- external sender warning banner
- blocked executable attachments
- blocked external auto-forwarding
- anti-spam policies
- anti-malware policies
- anti-phishing policies where available

Important mail flow rules:

| Rule | Purpose |
|---|---|
| External sender banner | Warn users about outside email |
| Block executable attachments | Reduce malware risk |
| Block external auto-forwarding | Reduce data leakage |
| Finance impersonation protection | Protect payments and invoices |
| Owner impersonation protection | Reduce CEO fraud |
| DMARC fail handling | Reduce spoofing |

Security alert mailbox:

`security@sammedsynlab.com`

## 25. DNS and Email Authentication

If the custom domain `sammedsynlab.com` is available, the admin should:

1. Add the domain in the Microsoft 365 admin center.
2. Verify ownership using a TXT record.
3. Add the required DNS records.
4. Confirm that email works with the custom domain.
5. Take screenshots of the domain status and DNS records.

Required DNS records:

- MX
- SPF
- DKIM
- DMARC
- Autodiscover

SPF example:

`v=spf1 include:spf.protection.outlook.com -all`

Start DMARC in monitor mode:

`v=DMARC1; p=none; rua=mailto:dmarc@sammedsynlab.com`

Later planned DMARC states:

- `p=quarantine`
- `p=reject`

## 26. Core Security Requirements

Configure or document:

- MFA for all users
- stronger MFA for admin accounts
- blocked legacy authentication where available
- separate admin accounts
- least privilege admin roles
- self-service password reset if available
- password reset testing
- sign-in review
- inactive account review

If Conditional Access is available, create these policies.

| Policy | Action |
|---|---|
| Require MFA for all users | All users must use MFA |
| Require MFA for admins | Admin portals require MFA |
| Block legacy authentication | Block old protocols |
| Require compliant device for admin access | Admin work only from managed devices |
| Restrict guest access | Limit guest sessions |
| Session control for Finance/HR | Shorter session lifetime |

If Conditional Access is not available, use Security Defaults and document Conditional Access as a planned Business Premium or Entra ID P1 improvement.

## 27. Defender and Email Security

If licensing supports it, configure:

- Microsoft Defender for Office 365 policies
- Safe Links
- Safe Attachments
- anti-phishing policy
- anti-spam policy
- anti-malware policy
- impersonation protection for owner and finance users
- quarantine policy
- security alert mailbox

If these features are not available in the current license, document them as planned improvements.

## 28. Service Health and Message Center

The admin must review Microsoft 365 service status.

Tasks:

1. Open the Microsoft 365 admin center.
2. Go to Health.
3. Check Service Health.
4. Check Message Center.
5. Identify active issues or upcoming changes.
6. Document one example message or service status item.

Required evidence:

- screenshot of Service Health
- screenshot of Message Center
- short note explaining why admins must monitor these pages

Purpose:

Service Health and Message Center monitoring is required because Microsoft 365 is a cloud service affected by Microsoft-side outages, updates, and platform changes.

## 29. Manual Access Review

If the license does not include automated Access Reviews, complete a manual permission review.

Review scope:

- Finance access
- HR access
- ITInfra access
- guest access
- SharePoint site permissions
- Microsoft 365 group membership
- Teams membership

Tasks:

1. Export users and groups.
2. Export group membership.
3. Review Finance group members.
4. Review HR group members.
5. Review guest users.
6. Confirm that only approved users have access.
7. Remove one test user from a group and confirm that access is removed.

Required evidence:

- group membership report
- SharePoint permission screenshot
- guest user review screenshot
- before/after access test

## 30. Incident Response Scenario

Simulate one small incident.

| Item | Value |
|---|---|
| Incident name | Suspicious Finance Account Access |
| User | `finance.assistant@sammedsynlab.com` |
| Scenario | A Finance user reports that they clicked a suspicious email link |

Response steps:

1. Block the user sign-in.
2. Reset the password.
3. Revoke active sessions if available.
4. Check mailbox forwarding rules.
5. Check recent sign-in activity if available.
6. Review group membership.
7. Confirm no Finance files were shared externally.
8. Re-enable the account after password reset and MFA confirmation.
9. Document the incident.

Required evidence:

- blocked user screenshot
- password reset screenshot
- mailbox forwarding check
- sign-in or audit check if available
- final incident report

## 31. Intune Device Management

This section is for Business Premium or trial licensing. If Intune is not included in the current plan, document this section as a planned upgrade.

Create these device groups if Intune is available.

| Device Group | Purpose |
|---|---|
| DG-SMLC-Windows-Company | Company Windows PCs/laptops |
| DG-SMLC-Mobile-BYOD | Personal phones/tablets |
| DG-SMLC-Admin-Devices | Admin workstations |
| DG-SMLC-Field-Laptops | Field engineer laptops |
| DG-SMLC-Shared-Kiosk | Shared/front-desk devices |

Compliance policy requirements:

- BitLocker enabled
- Microsoft Defender enabled
- firewall enabled
- password or PIN required
- screen lock enabled
- supported operating system version
- not jailbroken or rooted
- device marked non-compliant if requirements fail

Configuration profiles:

- Windows security baseline
- BitLocker
- Defender
- Windows Update rings
- OneDrive known folder move
- browser security
- block USB storage if required
- local admin control

Update rings:

| Ring | Members |
|---|---|
| Pilot | ITInfra |
| Early | TechOps |
| Broad | MgmtAdmin, BizOps, Finance, Branch |

## 32. Data Protection

Create sensitivity labels if licensing supports them.

| Label | Use |
|---|---|
| Public | Public content |
| Internal | Normal company files |
| Confidential | Sensitive internal files |
| Finance Confidential | Finance-only files |
| HR Confidential | HR-only files |
| Technical Restricted | IT and support documents |

Protection rules:

- Finance files are restricted to Finance.
- HR files are restricted to MgmtAdmin HR users.
- ITInfra files are restricted to ITInfra.
- Customer technical notes are stored in TechOps.
- Guest sharing requires approval.

If sensitivity labels are not available in the current license, document them as a planned improvement.

## 33. Retention Plan

Suggested retention plan:

| Data | Retention |
|---|---|
| Normal email | 3 years |
| Finance email/docs | 7 years |
| HR documents | 7 years |
| Support records | 3 years |
| Security logs | 1 year or more |
| Teams chats | Based on company policy |

This retention table is planning guidance only. A real company must follow local law and formal compliance requirements.

## 34. Backup and Recovery Planning

Microsoft 365 includes recovery and retention features, but the company should still plan for backup and recovery.

Backup planning should include:

- Exchange mailboxes
- SharePoint sites
- OneDrive files
- Teams data
- admin configuration exports
- user and license reports
- group membership reports

Suggested recovery test:

1. Delete a test SharePoint file.
2. Restore it.
3. Take screenshots.
4. Document the result.

## 35. Onboarding Workflow

Create an onboarding script or process.

Test user:

`new.techops01@sammedsynlab.com`

Steps:

1. Create the user account.
2. Set display name, department, job title, and office location.
3. Assign a license if one is available.
4. Add the user to the department group.
5. Add the user to the site group.
6. Add the user to Teams.
7. Configure mailbox access.
8. Assign shared mailbox access if needed.
9. Require MFA registration.
10. Confirm SharePoint access.
11. Confirm Teams access.
12. Confirm email access.

Expected result:

- The user can sign in.
- The user has email if licensed.
- The user is in the TechOps group.
- The user can access the TechOps site.
- The user cannot access the Finance site.

## 36. Offboarding Workflow

Create an offboarding script or process.

Test user:

`br.support02@sammedsynlab.com`

Steps:

1. Block sign-in.
2. Reset password.
3. Revoke sessions.
4. Remove the user from Teams.
5. Remove the user from groups.
6. Convert mailbox to shared mailbox if needed.
7. Transfer OneDrive ownership to the manager.
8. Remove the license after data review.
9. Disable or wipe company device if Intune is used.
10. Export a final user report.

Expected result:

- The user cannot sign in.
- The user is removed from groups.
- The mailbox is preserved or converted.
- Access is removed from SharePoint and Teams.

## 37. Access Control Test Cases

| Test | User | Expected Result |
|---|---|---|
| Finance isolation | `finance.assistant@sammedsynlab.com` | Can access Finance Team and Finance SharePoint; cannot access ITInfra private files or HR records |
| TechOps access | `software.support01@sammedsynlab.com` | Can access TechOps Team, Knowledge Base, and TechOps SharePoint; cannot access Finance or HR |
| Branch user access | `br.fieldops01@sammedsynlab.com` | Can access Branch Team, FieldOps resources, and TechOps field support resources; cannot access HQ Finance or ITInfra private files |
| IT admin account | `adm-sysadmin01@sammedsynlab.com` | Can manage SharePoint; cannot be used as a daily mailbox; MFA required; admin action visible in audit logs if available |
| Guest user | `vendor.tech@example.com` | Can access only an approved TechOps shared area; cannot browse internal sites; cannot access Finance, HR, or ITInfra |
| Manual permission review | N/A | Finance, HR, ITInfra, and guest access are reviewed and limited correctly |
| Incident response | `finance.assistant@sammedsynlab.com` | Sign-in is blocked, password reset is attempted, sessions are revoked if available, mailbox forwarding is reviewed, and a final report is created |

## 38. PowerShell Automation Scope

PowerShell should be the primary method for repeatable configuration and reporting.

PowerShell should be used for:

- connecting to Microsoft Graph
- creating users
- setting user properties
- assigning licenses
- creating groups
- adding group members
- creating admin accounts
- assigning supported admin roles
- creating distribution lists
- creating shared mailboxes
- assigning mailbox permissions
- creating Teams
- creating SharePoint sites where possible
- applying permissions where possible
- exporting reports
- testing group membership
- documenting final state
- blocking user sign-in
- resetting passwords
- reviewing group memberships
- exporting manual access review data

Use the web UI for:

- DNS domain verification if needed
- screenshots
- visual verification
- settings that are easier to confirm in the portal
- license or trial activation
- Service Health screenshots
- Message Center screenshots
- final visual recording

## 39. Required Reports

Export reports as CSV files or screenshots.

Required evidence includes:

- all users
- licensed users
- unlicensed users
- admin accounts
- admin role assignments
- Microsoft 365 groups
- security groups
- group membership
- shared mailboxes
- distribution lists
- Teams list
- SharePoint sites
- guest users
- external sharing settings
- MFA/security status
- service health screenshot
- message center screenshot
- manual permission review report
- incident response report
- Intune device/compliance status if available

Suggested report folder:

`SMLC-M365-Project-Reports`

## 40. Final Evidence Checklist

The final documentation package should include:

1. topology screenshot from the original network design
2. Microsoft 365 tenant home page
3. custom domain page, if available
4. DNS verification screenshot, if available
5. PowerShell script execution
6. users created
7. licenses assigned
8. groups created
9. admin accounts and roles
10. Teams created
11. SharePoint sites created
12. Finance access test success
13. Finance access denied test
14. branch user access test
15. guest restricted access test
16. Exchange shared mailboxes
17. distribution lists
18. mail flow/security rules
19. MFA/security configuration
20. Service Health screenshot
21. Message Center screenshot
22. manual permission review report
23. incident response example report
24. Intune policies if available
25. exported CSV reports
26. final architecture diagram
27. final README document

## 41. Administrative Competencies Covered

The project covers the following Microsoft 365 administration areas:

- user and license management
- groups and access control
- Teams administration
- SharePoint permissions
- OneDrive basics
- Exchange Online basics
- shared mailboxes and distribution lists
- DNS domain verification
- MFA and basic identity security
- manual permission review
- Service Health and Message Center monitoring
- basic incident response
- PowerShell automation
- reporting and documentation
- onboarding and offboarding
- guest access control
- basic backup and recovery planning

## 42. Final Scope Summary

SMLC started with a traditional network design containing headquarters, a branch office, departments, VLANs, firewalls, DMZ services, and branch connectivity. The Microsoft 365 configuration extends the same company structure into the cloud.

The final tenant should include users, groups, Teams, SharePoint sites, email, shared mailboxes, security controls, admin roles, service monitoring, permission review, access testing, and incident response documentation.

The completed environment should align the Microsoft 365 tenant with the company's operational structure and baseline security requirements.
