# Azure VM Setup & Monitoring (Windows + Linux)

Hands-on lab provisioning **two** free-tier Azure VMs (Windows Server + Ubuntu), enabling monitoring (platform metrics + VM Insights), and capturing evidence.

## Sub-Labs
- [Windows VM Lab](./Windows) — RDP (optional), CPU spike via PowerShell, Azure Monitor charts.
- [Linux VM Lab](./Linux) — SSH (optional), CPU spike via `yes`, Azure Monitor charts.

## Deliverables
For each OS, screenshots live in `./<OS>/screenshots/`:
- `overview.png` — VM Overview blade
- `metrics.png` — Azure Monitor chart (CPU + Network + Disk)
- `activitylog.png` — Activity Log (Create/Start/Stop events)

## Why this matters
Demonstrates core cloud admin skills: provisioning, enabling monitoring/insights, validating health & activity, and documenting results for a portfolio.
