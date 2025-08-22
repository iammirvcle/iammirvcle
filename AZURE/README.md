# Azure Labs (Compute • Security • Monitoring • IAM • Cost • IaC)

Hands-on Azure labs and PowerShell scripts you can deploy quickly. 


## 📂 Projects (quick links)

### Compute & Monitoring
- [VM Setup & Monitoring (Windows + Linux)](./AzureVM/)

### Secrets & Cost Governance
- [Azure Key Vault Lab](./azure%20key%20vault%20lab/)
- [Azure Budget Alerts](./Azure%20Budget%20alerts/)

### Endpoint Security & Ops
- [Defender + Firewall Audit](./defender%20firewall%20audit/)
- [EventLog – Failed Logons](./eventlog%20failed%20logons/)
- [File Integrity – Baseline & Compare](./file%20integrity%20baseline/)
- [Services Health (Self-Heal optional)](./services%20health/)
- [Patch Compliance Snapshot](./patch%20compliance%20snapshot/)

### ITAM & Provisioning
- [PC Asset Inventory](./inventory/)
- [Automated Software Installer (winget)](./software%20installer/)

### Infrastructure as Code
- [Terraform – Azure Minimal](./terraform%20azure%20minimal/)


## ✅ Outcomes (examples)
- Provisioned Windows/Linux VMs on **B1s**, enabled platform metrics & **VM Insights**, captured CPU/Network/Disk charts.
- Secured secrets in **Key Vault** and demonstrated **versioned rotation**.
- Set a **monthly budget** with 50/80/100% email alerts to prevent surprise spend.
- Improved endpoint hygiene with **Defender/Firewall checks**, **failed logon triage**, **file integrity drift** detection, **patch age** flags, and **service self-heal**.
- Standardized provisioning via **inventory collection**, **winget installer**, and **Terraform** for reproducible Azure resources.


## ▶️ How to run the scripts (PowerShell)
Most scripts write artifacts to an `output/` folder.

```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
# then cd into a project folder (e.g., ./inventory) and run the .ps1

