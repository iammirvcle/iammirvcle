# Local User Account Audit
PowerShell script that lists all local users and flags high-risk conditions.

**Flags**
- Disabled accounts
- Administrator group membership
- Inactive (>90 days or never logged in)
- Password never expires

**Output**
- `local-users-audit.csv` with full details
- `Findings.txt` summary for quick review
