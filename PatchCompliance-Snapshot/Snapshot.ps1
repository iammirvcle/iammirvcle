
**File:** `PatchCompliance-Snapshot/Snapshot.ps1`
```powershell
<# 
Patch Compliance Snapshot
- Lists installed updates via Get-HotFix
- Flags "OutOfDate" if last update older than ThresholdDays (default 30)
#>

param(
  [int]$ThresholdDays = 30
)

$outDir = Join-Path $PSScriptRoot "output"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
$csvPath = Join-Path $outDir "patch-snapshot.csv"

$hotfix = Get-HotFix | Sort-Object InstalledOn -Descending
$last   = $hotfix | Select-Object -First 1
$lastDate = if ($last) { $last.InstalledOn } else { (Get-Date "2000-01-01") }
$ageDays = [int]((Get-Date) - $lastDate).TotalDays
$outOfDate = $ageDays -gt $ThresholdDays

$os = Get-CimInstance Win32_OperatingSystem

[pscustomobject]@{
  Timestamp      = (Get-Date).ToString('s')
  ComputerName   = $env:COMPUTERNAME
  OS             = "$($os.Caption) $($os.Version)"
  OSBuild        = $os.BuildNumber
  LastPatchDate  = $lastDate.ToString("yyyy-MM-dd")
  PatchAgeDays   = $ageDays
  ThresholdDays  = $ThresholdDays
  OutOfDate      = $outOfDate
} | Export-Csv -NoTypeInformation -Path $csvPath

Write-Host "Snapshot written to $csvPath (OutOfDate=$outOfDate, PatchAgeDays=$ageDays)"
