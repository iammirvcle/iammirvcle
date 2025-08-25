<#
 Detects recent failed logons (Event ID 4625) and exports to CSV.
 Usage:
   .\FailedLogons.ps1 -Minutes 60
   .\FailedLogons.ps1 -Minutes 60 -OutPath .\output\failed-logons.csv
#>

[CmdletBinding()]
param(
  [int]$Minutes = 60,
  [string]$OutPath = "$PSScriptRoot\output\failed-logons.csv"
)

function Get-EventDataValue {
  param($Event, [string]$Name)
  try {
    $xml = [xml]$Event.ToXml()
    ($xml.Event.EventData.Data | Where-Object { $_.Name -eq $Name }).'#text'
  } catch { $null }
}

$start = (Get-Date).AddMinutes(-$Minutes)
$filter = @{
  LogName = 'Security'
  Id      = 4625
  StartTime = $start
}

$events = Get-WinEvent -FilterHashtable $filter -ErrorAction SilentlyContinue

$rows = foreach ($e in $events) {
  [pscustomobject]@{
    TimeCreated   = $e.TimeCreated.ToString('s')
    TargetUser    = Get-EventDataValue $e 'TargetUserName'
    TargetDomain  = Get-EventDataValue $e 'TargetDomainName'
    LogonType     = Get-EventDataValue $e 'LogonType'
    IpAddress     = Get-EventDataValue $e 'IpAddress'
    Workstation   = Get-EventDataValue $e 'WorkstationName'
    FailureReason = Get-EventDataValue $e 'FailureReason'
    Status        = Get-EventDataValue $e 'Status'
    SubStatus     = Get-EventDataValue $e 'SubStatus'
    Computer      = $e.MachineName
    RecordId      = $e.RecordId
  }
}

# Ensure output dir
$dir = Split-Path -Parent $OutPath
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

$rows | Sort-Object TimeCreated | Export-Csv -NoTypeInformation -Path $OutPath
Write-Host "Saved $($rows.Count) failed logons since $start to $OutPath"
