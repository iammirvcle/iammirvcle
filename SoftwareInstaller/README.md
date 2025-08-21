# Automated Software Installer (PowerShell + winget)

A PowerShell script that automates installing common IT tools via `winget`. Supports profiles (minimal, standard, dev) to customize the install set. Logs results and skips already-installed apps.

## Profiles
- **minimal:** 7-Zip, Chrome, VS Code  
- **standard:** + Notepad++, Git, VLC, PowerToys  
- **dev:** + Wireshark, PuTTY, WinSCP, Azure CLI, Docker, Postman  

## Run
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
.\Install-CommonApps.ps1 -Profile standard
