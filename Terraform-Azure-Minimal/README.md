# Terraform – Azure Minimal (RG + Storage)

Minimal Terraform configuration that creates:
- An **Azure Resource Group**
- A **Storage Account** (standard LRS)

## Prerequisites
- Terraform **>= 1.5**
- Azure CLI (`az`) authenticated:
```bash
az login
# Optional: select subscription
az account set --subscription "<SUBSCRIPTION_ID>"

## Use
```bash
terraform init
terraform plan -out tf.plan
terraform apply tf.plan

To destroy:
terraform destroy

## Outcome (example)
Created and destroyed RG + Storage via IaC in ~40 seconds, demonstrating reproducible, idempotent provisioning.
