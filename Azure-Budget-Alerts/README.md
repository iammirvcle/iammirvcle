# Azure Budget & Cost Alerts

Set a monthly budget with email alerts to prevent bill surprises.

## Steps
1. Azure Portal → **Cost Management + Billing** → **Budgets** → **Add**.
2. Scope: your subscription. Name: `Monthly-Budget`. Reset: **Monthly**.
3. Amount: `$10` (example). Alerts: 50%, 80%, 100% → add your email.
4. Save. Trigger some minimal usage (start/stop a B1s VM) and watch alerts as usage accrues.

## Outcome (example)
Created a $10 monthly budget with 50/80/100% alerts; validated alert email delivery after small VM usage.
