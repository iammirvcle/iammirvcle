# 👨🏾‍💻 Emir Taylor - Cybersecurity, IAM & Cloud Ops

Cybersecurity, IAM, and Cloud Ops professional focused on building secure, scalable IT solutions with real-world impact. This repo highlights hands-on labs and automation projects demonstrating IT asset management, identity security, and cloud administration.

🛡️ **Core Expertise**  
- **IAM:** Azure AD, Okta, CyberArk; MFA enforcement; least privilege  
- **Endpoint & SecOps:** PowerShell, Defender, event log triage, file integrity, service health, patch status  
- **Cloud:** Azure VM/Monitor/Key Vault/Budgets; AWS S3/CloudTrail/CloudWatch; OCI Cloud Guard/Vault/Budgets  
- **ITAM & Workflow:** ServiceNow/CMDB mindset, lifecycle tracking, automation  
- **IaC & Tooling:** Terraform (Azure), Git pre-commit secret scanning

☁️ Cloud Directories
- **Azure:** [/AZURE](./AZURE) — Compute/Monitoring, Key Vault, Budgets, security audits, provisioning, and IaC  
- **AWS:** [/AWS](./AWS) — S3 security & compliance, CloudTrail alarms, IAM MFA guardrail  
- **Oracle OCI:** [/ORACLE](./ORACLE) — Cloud Guard, secure Object Storage, Budgets & alerts


📂 Quick Links — Azure Labs
> All live under `/AZURE`.

### Compute & Monitoring
- [VM Setup & Monitoring (Windows + Linux)](./AZURE/AzureVM/)

### Secrets & Cost Governance
- [Azure Key Vault Lab](./AZURE/AzureKeyVault-Lab/)
- [Azure Budget Alerts](./AZURE/Azure-Budget-Alerts/)

### Endpoint Security & Ops
- [Defender + Firewall Audit](./AZURE/DefenderFirewall-Audit/)
- [EventLog – Failed Logons](./AZURE/EventLog-FailedLogons/)
- [File Integrity – Baseline & Compare](./AZURE/FileIntegrity-Baseline/)
- [Services Health (Self-Heal optional)](./AZURE/Services-Health/)
- [Patch Compliance Snapshot](./AZURE/PatchCompliance-Snapshot/)

### ITAM & Provisioning
- [IT Asset Inventory](./AZURE/Inventory/)
- [Automated Software Installer (winget)](./AZURE/SoftwareInstaller/)

### Infrastructure as Code
- [Terraform – Azure Minimal](./AZURE/Terraform-Azure-Minimal/)


🔗 Feel free to connect: 
LinkedIn: linkedin.com/in/emirtaylor
Blog: mirvcle.cloud/blog


## How to Run the Scripts
Most scripts are PowerShell and write to an `output/` folder (CSV, JSON, logs).

```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
# then cd into a project folder (e.g., ./AZURE/inventory) and run the .ps1


