# AWS S3 – Secure Bucket + Config Rule

Create a **private** S3 bucket with **Block Public Access** and **default encryption**, then enable an **AWS Config** managed rule to continuously check encryption.

## Steps (Console)
1. **S3 → Create bucket**
   - Name: `secure-bucket-<unique>`
   - Region: your closest
   - **Block all public access:** ✅ (checked)
   - **Default encryption:** Enable (SSE-S3). If you have KMS, choose SSE-KMS.
2. Upload a small test file.
3. **AWS Config → Rules → Add rule**
   - Managed rule: `s3-bucket-server-side-encryption-enabled`
   - Scope: All resources
   - Save and evaluate.

## Optional (CLI)
```bash
# create bucket (update region/name)
aws s3api create-bucket --bucket secure-bucket-12345 --region us-east-1 --create-bucket-configuration LocationConstraint=us-east-1

# block public access
aws s3api put-public-access-block \
  --bucket secure-bucket-12345 \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# default encryption (SSE-S3)
aws s3api put-bucket-encryption \
  --bucket secure-bucket-12345 \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
