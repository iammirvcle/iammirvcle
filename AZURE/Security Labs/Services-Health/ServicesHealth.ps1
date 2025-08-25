
**File:** `Services-Health/ServicesHealth.ps1`
```powershell
<# 
Services Health Reporter
- Checks a list of critical services for Running status and Auto start type
- Optional: -SelfHeal tries to start stopped services
#>

param(
  [string[]]$Services = @("WinDefend","wuauserv","EventLog","LanmanWorkstation"),
  [switch]$SelfHeal
)

$outDir = Join-Path $PSScriptRoot "output"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
$csvPath = Join-Path $outDir "services-health.csv"
$logPath = Join-Path $outDir "selfheal.log"

$rows = foreach ($name in $Services) {
  $s = Get-Service -Name $name -ErrorAction SilentlyContinue
  if (-not $s) {
    [pscustomobject]@{ Service=$name; Status="NotFound"; StartType=""; Action="" }
    continue
  }

  $startType = (Get-WmiObject -Class Win32_Service -Filter "Name='$name'").StartMode
  $action = ""

  if ($SelfHeal -and $s.Status -ne "Running") {
    try {
      Start-Service -Name $name -ErrorAction Stop
      $action = "Started"
    } catch { $action = "StartFailed: $($_.Exception.Message)" }
    $action | Out-File -FilePath $logPath -Append -Encoding utf8
  }

  [pscustomobject]@{
    Service   = $name
    Status    = $s.Status
    StartType = $startType
    Action    = $action
  }
}

$rows | Export-Csv -NoTypeInformation -Path $csvPath
Write-Host "Report: $csvPath"
if ($SelfHeal) { Write-Host "Self-heal log: $logPath" }
