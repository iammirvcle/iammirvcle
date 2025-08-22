# PC Asset Inventory Script

A simple PowerShell script that captures device hardware/software details and exports them to a CSV file for IT Asset Management (ITAM).

## Features
- Captures: Computer name, OS/build, CPU, RAM, disk totals/free, serial number, IP address, installed app count, logged-in user.
- Outputs to `output/asset-inventory.csv`.
- Useful for onboarding, lifecycle tracking, or quick audits.

## Run
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
.\Inventory.ps1

## Outcome (example)
Captured a full hardware/software baseline for a test device in ~5 seconds; template scales to fleet CSV exports for CMDB/ServiceNow, saving ~10–15 minutes per device vs manual collection.
