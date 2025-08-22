# OCI Object Storage – Private, Encrypted Bucket (Vault/KMS)

Create a private bucket, enforce encryption with a **customer-managed key** from **OCI Vault**.

## Steps
1. **Identity & Security → Vault**
   - Create **Vault** (e.g., `vault-lab`) and a key (e.g., `cmk-obj`).
2. **Storage → Object Storage → Create bucket**
   - Name: `secure-bucket-<unique>`
   - Default storage tier: Standard
   - **Visibility:** Private
   - **Encryption:** Choose **Encrypt using a customer-managed key**, select your key.
3. Upload a small file and verify encryption metadata on the object.

## Evidence to capture
- Bucket details showing **Private** and **KMS key**
- Vault key page showing key usage

## Outcome (example)
Provisioned a private bucket encrypted with a customer-managed key, meeting stricter security requirements.
