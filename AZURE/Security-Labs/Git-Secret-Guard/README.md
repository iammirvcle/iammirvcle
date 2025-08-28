# Git Secret Guard – Pre-Commit Hook

Lightweight pre-commit hook to block committing **secrets** (e.g., keys, tokens, private keys). Works on Windows (PowerShell) and macOS/Linux (Bash).

## What it scans
- AWS access keys (e.g., `AKIA...`)
- Private keys (`-----BEGIN ... PRIVATE KEY-----`)
- Common patterns: `api_key=`, `secret`, `password`, Slack tokens, etc.

## Install (per repository)

### 1. Point Git to this repo’s hooks
```bash
git config core.hooksPath Git-Secret-Guard/hooks

windows - no extra steps (powershell 7, autorun)

linux/mac - make it executable
chmod +x Git-Secret-Guard/hooks/pre-commit

test it
git add example.txt
git commit -m "test hook"

## Outcome (example)
Blocked a commit containing a mock Slack token during testing, preventing accidental secret leakage into the repo.
