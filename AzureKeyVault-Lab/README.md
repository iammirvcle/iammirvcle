
**File:** `AzureKeyVault-Lab/README.md`
```markdown
# Azure Key Vault – Secrets & Rotation Lab

Creates a Key Vault, stores a secret, retrieves it, rotates it, and documents the process with screenshots.

## Steps (Portal)
1. Create resource group `rg-kv-lab`.
2. Create **Key Vault** `kv-lab-<unique>` in the same region.
3. In **Secrets**:
   - Add secret: Name `db-password`, Value `InitialP@ss!`.
   - Copy the Secret Identifier URL.
4. Retrieve + rotate:
   - Add a **new version** with a different value (`RotatedP@ss!`).
5. Capture screenshots:
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
