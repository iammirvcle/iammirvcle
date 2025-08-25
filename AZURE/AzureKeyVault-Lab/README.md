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

## Optional (PowerShell)
```powershell
# Requires Az.Accounts, Az.KeyVault
Connect-AzAccount
New-AzResourceGroup -Name rg-kv-lab -Location eastus
$kv = New-AzKeyVault -Name "kv-lab-$(Get-Random)" -ResourceGroupName rg-kv-lab -Location eastus
Set-AzKeyVaultSecret -VaultName $kv.VaultName -Name "db-password" -SecretValue (ConvertTo-SecureString "InitialP@ss!" -AsPlainText -Force)
(Get-AzKeyVaultSecret -VaultName $kv.VaultName -Name "db-password").SecretValueText
Set-AzKeyVaultSecret -VaultName $kv.VaultName -Name "db-password" -SecretValue (ConvertTo-SecureString "RotatedP@ss!" -AsPlainText -Force)
