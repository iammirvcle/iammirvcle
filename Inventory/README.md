# PC Asset Inventory Script
Simple PowerShell script that captures device hardware/software basics into a CSV for ITAM.

**Outputs:** Computer name, OS/build, CPU, RAM, disk totals, serial, IP, user, installed app count.

**Run**
- Open PowerShell (Admin), `Set-ExecutionPolicy -Scope CurrentUser Bypass -Force`
- `.\Inventory.ps1` → CSV saved to `output\asset-inventory.csv`

**Use cases**
- First-pass inventory during onboarding
- Pre-reimage snapshot
- Quick audit for aging/EOL devices
