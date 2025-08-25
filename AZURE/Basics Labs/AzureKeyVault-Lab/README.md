# Azure Key Vault – Secrets & Rotation Lab

Creates a Key Vault, stores a secret, retrieves it, rotates it, and documents the process with screenshots.

## Steps (Portal)
1. In the search bar, type Key Vaults → Click + Create.
2. Fill out:

   Subscription → Same as above.

   Resource group → rg-free-tier-lab

   Key Vault name → must be globally unique, e.g. kv-lab-yourinitials

   Region → East US (same as RG).

   Pricing tier → Select Standard (✅ free-tier friendly).

4. Under Access Configuration, leave default as Vault access policy unless lab says otherwise.

5. Click Review + Create → Create.

6. Capture screenshots:
   - Vault Overview (`screenshots/overview.png`)
   - Secrets list (`screenshots/secrets.png`)
   - Secret versions (`screenshots/versions.png`)


6. 🔑 Key Vault Permission Models

   1. Vault Access Policy (Legacy)

      The old way of controlling access.

      		You create explicit access policies inside the Key Vault itself.

      		Example: Give Emir “Secret Get + List” permissions.

     		 Management is per vault → gets messy if you have many Key Vaults.

     		 No role granularity → you pick checkboxes (Secrets, Keys, Certificates), not the full RBAC model.

   👉 Best for: small labs, simple one-off use cases.



    2. Azure RBAC (Role-Based Access Control)
   
   		The modern, recommended way.

     		 Uses Azure AD roles and scopes (subscription → resource group → resource).

      		Access is assigned just like any other Azure resource: you give someone a role like Key Vault Secrets User at the resource group or vault level.

      		Scales better → one role assignment can cover many vaults.

      		Auditing and consistency is easier since it’s all centralized in Azure AD.

   		👉 Best for: production, enterprise, and free-tier labs (because Microsoft recommends it).


## ⚖️ Key Differences to Understand based on Scope, Granularity, Adubitability, and Reccomendation.


Vault Access Policy, Only applies inside one vault, Coarse (Secrets/Keys/Certs), Harder, not centralized,  ❌ Legacy          

Azure RBAC,  Works across subscription / RG / vault, Fine-grained RBAC roles, Centralized in Azure AD logs, ✅ Microsoft best practice



When you create your Key Vault, choose "Azure RBAC" for the permission model.

This means:

	You won’t set access inside the vault directly.

	Instead, you’ll assign yourself (or a service principal) an Azure role like:

   	Key Vault Reader (read metadata)

   	Key Vault Secrets User (get/list secrets)

   	Key Vault Administrator (full control).
