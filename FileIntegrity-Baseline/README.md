# File Integrity – Baseline & Compare

PowerShell script to create a **baseline** of file hashes (SHA-256) for a directory and later **compare** to detect added, removed, or modified files.

## Features
- Baseline: Recursively record file path, size, modified time, and SHA-256 hash
- Compare: Report files added/removed/modified since the baseline
- Cross-platform with PowerShell 7 (Windows/macOS/Linux)

## Run

### 1) Create a baseline
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
.\FIM.ps1 -Path "C:\Important" -BaselineOut .\baseline.json
