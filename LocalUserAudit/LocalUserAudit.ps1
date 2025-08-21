# Local User Account Audit
PowerShell script that lists all local users and flags high-risk conditions.

**Flags:** Disabled accounts, Administrator membership, Inactive (>90 days or never logged in), Password never expires.

## Run
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
.\LocalUserAudit.ps1
