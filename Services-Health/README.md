# Services Health (with optional self-heal)

Checks critical Windows services for **Running** status and **Automatic** start type; can attempt to start stopped services.

## Run
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
.\ServicesHealth.ps1 -Services "WinDefend","wuauserv","EventLog","LanmanWorkstation" -SelfHeal

output/services-health.csv
(Optional) output/selfheal.log if -SelfHeal is used
