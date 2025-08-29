# 📦 Inventory Script Lab

## 📌 Overview
This lab demonstrates how to collect and track **IT asset inventory** using PowerShell scripts.  
It covers both **endpoint inventory** (hardware, OS, applications, BitLocker, users) and **Azure resource inventory** (cloud resources by subscription or resource group).  

The outputs are **JSON** (detailed) and **CSV** (summary), making them easy to archive, audit, or upload into an ITAM system.



## 🧩 Lab Objectives
- Collect endpoint inventory (hardware, OS, network, apps, BitLocker)  
- Collect Azure subscription or resource group inventory  
- Save outputs in JSON + CSV for easy reporting  
- Optionally upload results to **Azure Storage** using a SAS token  



## ⚙️ Endpoint Inventory – `Get-Inventory.ps1`
Collects **local system information** from a Windows machine.

### Run
```powershell
# Run as Administrator (recommended for BitLocker info)
Set-ExecutionPolicy Bypass -Scope Process -Force
.\Get-Inventory.ps1 -OutDir C:\Inventory
