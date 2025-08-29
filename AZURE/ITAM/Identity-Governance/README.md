# 🛡️ Identity-Governance Lab

## 📌 Overview
This lab demonstrates **Azure AD Identity Governance** concepts using **Conditional Access** and **Privileged Identity Management (PIM)**.  
The goal is to enforce **least privilege** and **just-in-time access** while maintaining an auditable trail of admin actions.  



## 🧩 Lab Objectives
- Enforce MFA for administrator accounts (Conditional Access)  
- Configure just-in-time role assignments (PIM)  
- Review audit logs to confirm governance and accountability  



## ⚙️ Step 1 – Conditional Access Policy
- In Azure Portal → Azure AD → Security → Conditional Access → + New policy.
- Policy: `Require-MFA-for-Admins`  
- Applied to: `Lab-Admins` group
- Cloud apps → All apps.
- Control: Require **Multi-Factor Authentication**
- Enable the policy.
📸 *[screenshot]*  



## 🔑 Step 2 – Privileged Identity Management (PIM)
- Go to Azure AD → Privileged Identity Management (PIM).
- Under Azure AD roles → choose labadmin.
- Configure:
  - Role: User Administrator.
  - Assignment type: Eligible (not permanent).
  - Require justification and MFA for activation.
- Save policy.
📸 *[screenshot]*  



## ⏱️ Step 3 – Role Activation
- Sign in as 'labadmin'.
- `labadmin` requested activation of User Administrator role  
- Justification submitted + MFA approved  
- Role granted temporarily (1 hour)  
📸 *[screenshot]*  



## 📜 Step 4 – Audit Logs
- Verified in Azure AD → Audit logs  
- Events captured: role request, MFA enforcement, activation approval  
📸 *[screenshot]*  



## ✅ Lab Outputs
- [x] Conditional Access requiring MFA for admins  
- [x] PIM configured for just-in-time access  
- [x] Audit logs confirmed policy enforcement  



## 🔎 Reflection
This lab reinforced the importance of:  
- **Conditional Access** for enforcing modern security policies  
- **Privileged Identity Management (PIM)** for reducing standing admin rights  
- **Audit logging** for compliance and traceability  

These practices are essential for **Identity Governance, IAM engineering, and cloud security operations**.  


