# Azure Labs 

Hands-on Azure labs and PowerShell scripts you can deploy quickly. 


## 📂 Projects (quick links)

### Compute & Monitoring
- [VM Setup & Monitoring (Windows + Linux)](./Deployment-Labs/AzureVM/)

### Secrets & Cost Governance
- [Azure Key Vault Lab](./Deployment-Labs/AzureKeyVault-Lab/)
- [Azure Budget Alerts](./Deployment-Labs/Azure-Budget-Alerts/)

### Endpoint Security & Ops
- [Defender + Firewall Audit](./Security-Labs/DefenderFirewall-Audit/)
- [EventLog – Failed Logons](./Security-Labs/EventLog-FailedLogons/)
- [File Integrity – Baseline & Compare](./Security-Labs/FileIntegrity-Baseline/)
- [Services Health (Self-Heal optional)](./Security-Labs/Services-Health/)
- [Patch Compliance Snapshot](./Security-Labs/PatchCompliance-Snapshot/)

### ITAM & Provisioning
- [IT Asset Inventory](./ITAM/Inventory/)
- [Automated Software Installer (winget)](./ITAM/SoftwareInstaller/)

### Infrastructure as Code
- [Terraform – Azure Minimal](./IaC/Terraform-Azure-Minimal/)


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

