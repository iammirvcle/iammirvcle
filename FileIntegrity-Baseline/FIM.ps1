<#
 Simple File Integrity Monitor (baseline + compare).
 Usage:
   Baseline: .\FIM.ps1 -Path "C:\Important" -BaselineOut .\baseline.json
   Compare : .\FIM.ps1 -Path "C:\Important" -BaselineIn  .\baseline.json -ReportOut .\report.json
#>

[CmdletBinding(DefaultParameterSetName='Baseline')]
param(
  [Parameter(Mandatory=$true)]
  [string]$Path,

  [Parameter(ParameterSetName='Baseline', Mandatory=$true)]
  [string]$BaselineOut,

  [Parameter(ParameterSetName='Compare', Mandatory=$true)]
  [string]$BaselineIn,

  [Parameter(ParameterSetName='Compare')]
  [string]$ReportOut = "$PSScriptRoot\report.json"
)

function Get-FileHashRecord {
  param([string]$File)
  try {
    $h = Get-FileHash -Algorithm SHA256 -Path $File
    [pscustomobject]@{
      RelPath = Resolve-Path -LiteralPath $File -Relative
      Hash    = $h.Hash
      Size    = (Get-Item $File).Length
      Modified= (Get-Item $File).LastWriteTimeUtc
    }
  } catch {}
}

$resolved = Resolve-Path -LiteralPath $Path
Push-Location $resolved.Path
try {
  if ($PSCmdlet.ParameterSetName -eq 'Baseline') {
    $files = Get-ChildItem -Recurse -File -Force
    $records = $files | ForEach-Object { Get-FileHashRecord $_.FullName }
    $json = $records | ConvertTo-Json -Depth 4
    $outDir = Split-Path -Parent $BaselineOut
    if ($outDir -and -not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
    $json | Out-File -FilePath $BaselineOut -Encoding utf8
    Write-Host "Baseline written to $BaselineOut ($($records.Count) files)."
  } else {
    $baseline = Get-Content -Raw -Path $BaselineIn | ConvertFrom-Json
    $current  = Get-ChildItem -Recurse -File -Force | ForEach-Object { Get-FileHashRecord $_.FullName }

    $byPathBase = @{}; foreach ($b in $baseline) { $byPathBase[$b.RelPath] = $b }
    $byPathCurr = @{}; foreach ($c in $current ) { $byPathCurr[$c.RelPath] = $c }

    $added    = @(); $removed = @(); $modified = @()

    foreach ($p in $byPathCurr.Keys) {
      if (-not $byPathBase.ContainsKey($p)) { $added += $byPathCurr[$p]; continue }
      if ($byPathBase[$p].Hash -ne $byPathCurr[$p].Hash) { $modified += [pscustomobject]@{ RelPath=$p; OldHash=$byPathBase[$p].Hash; NewHash=$byPathCurr[$p].Hash } }
    }
    foreach ($p in $byPathBase.Keys) {
      if (-not $byPathCurr.ContainsKey($p)) { $removed += $byPathBase[$p] }
    }

    $report = [pscustomobject]@{
      Path     = $resolved.Path
      Timestamp= (Get-Date).ToString('s')
      Added    = $added
      Removed  = $removed
      Modified = $modified
    }

    $outDir = Split-Path -Parent $ReportOut
    if ($outDir -and -not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
    ($report | ConvertTo-Json -Depth 6) | Out-File -FilePath $ReportOut -Encoding utf8

    Write-Host ("Report written to {0}. Added:{1} Removed:{2} Modified:{3}" -f $ReportOut,$added.Count,$removed.Count,$modified.Count)
  }
}
finally { Pop-Location }
