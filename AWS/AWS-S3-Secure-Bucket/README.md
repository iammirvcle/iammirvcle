# AWS S3 – Secure Bucket with Config Rule

Creates a private S3 bucket with **Block Public Access**, **default SSE encryption**, and enables an **AWS Config** managed rule to monitor encryption.

## Steps (Console)
1. S3 → Create bucket: `secure-bucket-<unique>` → Block all public access (checked).
2. Default encryption: **SSE-S3** (AES-256) or **SSE-KMS** if you have a CMK.
3. Upload a test object.
4. AWS Config → **Add rule**: `s3-bucket-server-side-encryption-enabled`.
5. View rule evaluation for your bucket (COMPLIANT).

## Outcome (example)
Provisioned a private, encrypted S3 bucket and validated continuous compliance via AWS Config.
