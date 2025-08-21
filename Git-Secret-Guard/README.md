
```markdown
# Git Secret Guard – Pre-Commit Hook

Lightweight pre-commit hook to block committing **secrets** (e.g., keys, tokens, private keys). Works on Windows (PowerShell) and macOS/Linux (Bash).

## What it scans
- AWS access keys (e.g., `AKIA...`)
- Private keys (`-----BEGIN ... PRIVATE KEY-----`)
- Common patterns: `api_key=`, `secret`, `password`, Slack tokens, etc.

## Install (per repository)

### 1) Point Git to this repo’s hooks
```bash
git config core.hooksPath Git-Secret-Guard/hooks
