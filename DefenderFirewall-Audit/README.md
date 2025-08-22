# Defender + Firewall Health Audit

Audits Microsoft Defender status (real-time, signatures, scan history, threats) and Windows Firewall profile states. Exports CSV + Findings.txt.

## Run
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
.\Audit.ps1

output/defender-firewall.csv
output/Findings.txt
