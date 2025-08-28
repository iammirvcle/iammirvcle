<#
 Simple pre-commit hook to block committing secrets.
 Install:
   git config core.hooksPath Git-Secret-Guard/hooks
   # On Windows, associate .ps1 pre-commit via a small cmd shim (below) OR rename to 'pre-commit' and run with pwsh
#>

$ErrorActionPreference = 'SilentlyContinue'
$diff = git diff --cached -U0

$patterns = @(
  'AKIA[0-9A-Z]{16}',               # AWS Access Key
  '-----BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY-----',
  'xox[baprs]-[0-9A-Za-z-]{10,48}', # Slack token
  'secret[_-]?key\s*=\s*["''][0-9A-Za-z\/+]{16,}["'']',
  'password\s*=\s*["''][^"'']{6,}["'']',
  'api[_-]?key\s*=\s*["''][0-9A-Za-z\-_/+=]{16,}["'']'
)

$matches = @()
foreach ($p in $patterns) {
  $m = Select-String -InputObject $diff -Pattern $p -AllMatches
  if ($m) { $matches += $m }
}

if ($matches.Count -gt 0) {
  Write-Host "❌ Secret-like patterns detected in staged changes. Commit aborted.`n"
  $matches | ForEach-Object { $_.Line | Write-Host "  → " $_ }
  exit 1
}
exit 0
