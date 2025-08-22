# IAM – Enforce MFA (Deny Without MFA Guardrail)

A safe, scoped **deny** policy that blocks actions when **MFA is not present**, while allowing users to set up MFA.

> ⚠️ Test in a sandbox. Attach to a **group** used by non-break-glass users. Keep at least one break-glass admin without this policy.

## Steps
1. **Create IAM group** `BaselineDenyNoMFA`.
2. **Add inline policy** to the group (JSON below).
3. Add a test user to this group, sign in **without MFA**, verify denies.
4. Enroll MFA, sign in **with MFA**, verify normal access.

## Policy (Deny actions if MFA not present)
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllUnlessMFA",
      "Effect": "Deny",
      "NotAction": [
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:ListMFADevices",
        "iam:ListVirtualMFADevices",
        "iam:ResyncMFADevice",
        "iam:AssociateMFADevice",
        "iam:DeactivateMFADevice",
        "iam:DeleteVirtualMFADevice",
        "sts:GetSessionToken",
        "iam:GetUser",
        "iam:ListUsers",
        "iam:ListAccountAliases",
        "iam:ListRoles",
        "iam:ListPolicies"
      ],
      "Resource": "*",
      "Condition": { "BoolIfExists": { "aws:MultiFactorAuthPresent": "false" } }
    }
  ]
}
