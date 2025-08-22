# CloudTrail + CloudWatch – Root & Unauthorized API Alarms

Enable account activity visibility and alert on risky events: **root usage** and **unauthorized API calls**.

## Steps (Console)
1. **CloudTrail**
   - Trails → Create trail → Name `org-or-account-trail`
   - Apply to all regions: ✅
   - Create S3 log bucket (auto) → Create.
2. **CloudWatch Logs**
   - Create Log group `CloudTrail/Logs` (if CloudTrail didn't make one).
   - Ensure the trail is delivering to this log group (via CloudTrail settings).
3. **Metric Filters** (CloudWatch Logs → Log group → Metric filters)
   - **Unauthorized API Calls** pattern:
     ```
     { ($.errorCode="AccessDenied*" || $.errorCode="UnauthorizedOperation") }
     ```
     Metric name: `UnauthorizedAPICalls`
   - **Root User Usage** pattern:
     ```
     { ($.userIdentity.type="Root") && !($.userIdentity.invokedBy EXISTS) }
     ```
     Metric name: `RootUserUsage`
4. **SNS Topic** (Simple Notification Service)
   - Create topic `sec-alerts`, add email subscription, **confirm** the email.
5. **Alarms** (CloudWatch → Alarms → Create)
   - Alarm on `UnauthorizedAPICalls` ≥ 1 in 5 min → notify `sec-alerts`
   - Alarm on `RootUserUsage` ≥ 1 in 5 min → notify `sec-alerts`

## Evidence to capture
- CloudTrail trail page (multi-region ON)
- CloudWatch metric filters
- Two alarms in **ALARM/OK** states
- SNS subscription **Confirmed**

## Outcome (example)
Deployed alarms that email on root usage and unauthorized API calls, improving detection coverage within 15 minutes.
