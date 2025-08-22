# Patch Compliance Snapshot

Creates a simple patch-age report and flags the device as **OutOfDate** if the last installed update is older than a threshold (default 30 days).

## Run
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
.\Snapshot.ps1 -ThresholdDays 30
