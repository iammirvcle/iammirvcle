# 🔑 AzureAD-Lab

## 📌 Overview
This lab demonstrates the fundamentals of **Azure Active Directory (Azure AD)** for identity and access management.  
I created a dedicated tenant, provisioned users and groups, applied **RBAC (role-based access control)**, and enforced **Conditional Access policies**.  

This is a sim pf real-world identity governance workflows that system administrators and IAM engineers use to manage cloud access securely.



## 🧩 Lab Objectives
- Create and configure an **Azure AD tenant**
- Add **users** and assign them to **groups**
- Apply **role assignments (RBAC)** at subscription scope
- Integrate a **custom domain** (optional)
- Configure a **Conditional Access policy** requiring MFA



## ⚙️ Step 1 – Create an Azure AD Tenant
- In the Azure Portal → search Azure Active Directory.
- By default, your subscription already has a tenant (Default Directory).
- For lab purposes, you can either use that OR create a new tenant:
- Click Manage tenants → + Create.
- Created a new tenant named `MirvcleAD-Lab`  
- Domain: `mirvclelab.onmicrosoft.com`
- 
📸 *[screenshot of tenant overview page]*



## 👥 Step 2 – Create Users
- In your Azure AD tenant → Users → + New User.
- Added two users:  
  - `labadmin@mirvclelab.onmicrosoft.com`  
  - `labuser@mirvclelab.onmicrosoft.com`  
- Assigned temporary passwords.

📸 *[screenshot of users list]*



## 👤 Step 3 – Create Groups
- Go to Groups → + New Group.
Type: Security
- Created Security Groups:  
  - `Lab-Admins` → contains `labadmin`  
  - `Lab-Users` → contains `labuser`

📸 *[screenshot of groups list]*



## 🔒 Step 4 – Assign Roles
- Go to Azure AD → Roles and administrators.
- Assigned `labadmin` → **User Administrator** role  
- Left `labuser` with default privileges (no role)  
- Demonstrates **least privilege principle**.

📸 *[screenshot of role assignments]*



## 🌐 Step 5 – Add Custom Domain (Optional)
- If you own a domain (ex. mirvcle.cloud) , add it to Azure AD.
Azure AD → Custom domain names → + Add custom domain.
- Linked `mirvcle.cloud` domain to Azure AD  
- Verified via TXT DNS record  
- Enabled creation of users like `user1@mirvcle.cloud`.

📸 *[screenshot of domain settings]*



## 🔐 Step 6 – Configure Conditional Access
- Go to Security → Conditional Access → + New policy.
- Policy: `MFA for Lab-Admins`  
- Applies only to **Lab-Admins group**  
- Requires **Multi-Factor Authentication** on sign-in.
- Save The Policy.

📸 *[screenshot of Conditional Access policy]*



## ✅ Lab Outputs
- [x] Azure AD tenant deployed  
- [x] Users & groups created  
- [x] Roles assigned via RBAC  
- [x] Conditional Access enforced  
- [x] Custom domain added (optional)



## 🔎 Reflection
This lab reinforced key Azure AD concepts:
- How Azure AD tenants provide centralized identity control.  
- Difference between **groups** vs. **roles** in access management.  
- How **Conditional Access** enforces modern security (MFA, device compliance).  

These skills map directly to **system administration, IAM engineering, and cloud security administration** roles.


