# Local User Account Audit

A PowerShell script that audits all local accounts on a Windows system and generates both a CSV and summary text report.

## Features
- Lists all local accounts.
- Flags:
  - Disabled accounts
  - Administrator membership
  - Inactive accounts (>90 days or never logged in)
  - Password never expires
- Outputs:
  - `output/local-users-audit.csv`
  - `output/Findings.txt`

## Run
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
.\LocalUserAudit.ps1
## Outcome (example)
Identified 2 inactive local accounts (1 with admin rights) on a test box, providing clear evidence (CSV + summary) for privilege cleanup and IAM hygiene.
