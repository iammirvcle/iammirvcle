<# 
Defender + Firewall Health Audit
- Collects Microsoft Defender status and Windows Firewall profile states
- Exports CSV + Findings.txt summary
#>

$outDir = Join-Path $PSScriptRoot "output"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
$csvPath = Join-Path $outDir "defender-firewall.csv"
$txtPath = Join-Path $outDir "Findings.txt"

# Defender (works when Defender is present/active)
try {
    $mp = Get-MpComputerStatus
} catch { $mp = $null }

# Firewall profiles
$fwDomain  = Get-NetFirewallProfile -Profile Domain
$fwPrivate = Get-NetFirewallProfile -Profile Private
$fwPublic  = Get-NetFirewallProfile -Profile Public

$record = [pscustomobject]@{
  Timestamp                = (Get-Date).ToString('s')
  ComputerName             = $env:COMPUTERNAME

  Defender_RealTime        = if ($mp) { $mp.RealTimeProtectionEnabled } else { $null }
  Defender_SignatureAgeHrs = if ($mp) { [int]((Get-Date) - $mp.AMSISignatureLastUpdated).TotalHours } else { $null }
  Defender_LastQuickScan   = if ($mp -and $mp.QuickScanEndTime) { $mp.QuickScanEndTime.ToString('s') } else { "" }
  Defender_LastFullScan    = if ($mp -and $mp.FullScanEndTime)  { $mp.FullScanEndTime.ToString('s') } else { "" }
  Defender_ThreatsFound    = if ($mp) { $mp.ThreatsFound } else { $null }

  FW_Domain_Enabled        = $fwDomain.Enabled
  FW_Private_Enabled       = $fwPrivate.Enabled
  FW_Public_Enabled        = $fwPublic.Enabled
  FW_Domain_DefaultAction  = $fwDomain.DefaultInboundAction
  FW_Private_DefaultAction = $fwPrivate.DefaultInboundAction
  FW_Public_DefaultAction  = $fwPublic.DefaultInboundAction
}

$record | Export-Csv -NoTypeInformation -Path $csvPath

# Findings
$rtp = if ($record.Defender_RealTime) { "ON" } else { "OFF/NA" }
$fw  = @()
if (-not $record.FW_Domain_Enabled)  { $fw += "Domain" }
if (-not $record.FW_Private_Enabled) { $fw += "Private" }
if (-not $record.FW_Public_Enabled)  { $fw += "Public" }
$fwMsg = if ($fw.Count -gt 0) { "Firewall disabled on: " + ($fw -join ", ") } else { "Firewall enabled on all profiles" }

@"
Defender + Firewall Audit - $(Get-Date -Format s)

Computer: $($record.ComputerName)

Defender
- Real-time protection: $rtp
- Signature age (hrs):  $($record.Defender_SignatureAgeHrs)
- Last quick scan:      $($record.Defender_LastQuickScan)
- Last full scan:       $($record.Defender_LastFullScan)
- Threats found:        $($record.Defender_ThreatsFound)

Firewall
- $fwMsg

CSV: $csvPath
"@ | Out-File -FilePath $txtPath -Encoding UTF8

Write-Host "Audit saved:`n- $csvPath`n- $txtPath"
