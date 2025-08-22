# EventLog – Failed Logons (Windows)

PowerShell script that scans the Windows **Security** event log for recent failed sign-ins (**Event ID 4625**) and exports results to CSV.

## Features
- Filters by a time window (e.g., last 60 minutes)
- Extracts user, domain, IP address, logon type, failure reason
- Saves results to a CSV for investigation or reporting

## Requirements
- Windows with PowerShell 5+ (run as Administrator for Security log access)

## Run
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
.\FailedLogons.ps1 -Minutes 60 -OutPath .\output\failed-logons.csv

output/failed-logons.csv with columns:
TimeCreated, TargetUser, TargetDomain, LogonType, IpAddress, Workstation, FailureReason, Status, SubStatus, Computer, RecordId

## Outcome (example)
Surfaced 12 failed logons in the last hour (same source IP), enabling quick triage of a password-spray attempt.
