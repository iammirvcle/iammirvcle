# OCI Budgets & Cost Alerts (ONS)

Set a monthly budget and send alerts via **Oracle Notifications (ONS)** to email.

## Steps
1. **Developer Services → Notifications**
   - Create **Topic** `cost-alerts` → Add **Email** subscription → **Confirm** the email.
2. **Cost Management → Budgets → Create budget**
   - Scope: Subscription/Tenancy or a specific compartment
   - Reset period: Monthly
   - Amount: e.g., $10
   - **Alert Rule(s):** 50%, 80%, 100% thresholds
   - Delivery: select **Notifications topic** `cost-alerts`
3. Generate a little usage (start/stop a small instance) to see usage climb.

## Evidence to capture
- Budget page with thresholds
- Notifications topic with **Confirmed** email
- Example alert email (screenshot)

## Outcome (example)
Configured a $10 monthly budget with alerts at 50/80/100% and validated email notifications via ONS.
