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
