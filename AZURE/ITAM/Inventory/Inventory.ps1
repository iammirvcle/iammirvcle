<#  
.SYNOPSIS
  Collects endpoint inventory: hardware, OS, disks, network, BitLocker, apps, local users.
  Outputs JSON + CSV; optional upload to Azure Blob (SAS URL).

.EXAMPLE
  .\Get-Inventory.ps1 -OutDir C:\Inventory

.EXAMPLE
  .\Get-Inventory.ps1 -OutDir C:\Inventory -SasUrl "https://<acct>.blob.core.windows.net/<container>?<SAS>"
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [string]$OutDir,

  # Optional SAS URL to a blob *folder-like* path (container or virtual dir). Script appends filenames.
  [string]$SasUrl = ""
)

function Test-Admin {
  $id = [Security.Principal.WindowsIdentity]::GetCurrent()
  $p  = New-Object Security.Principal.WindowsPrincipal($id)
  return $p.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

$timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
$hostname  = $env:COMPUTERNAME
$baseName  = "${hostname}_$timestamp"
$jsonPath  = Join-Path $OutDir "$baseName.json"
$csvPath   = Join-Path $OutDir "$baseName.csv"

# ---------- Collect: OS / Hardware ----------
$os   = Get-CimInstance Win32_OperatingSystem
$cs   = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_BIOS
$cpu  = Get-CimInstance Win32_Processor
$mem  = Get-CimInstance Win32_PhysicalMemory | Select-Object Capacity, Manufacturer, PartNumber, SerialNumber
$gpu  = Get-CimInstance Win32_VideoController | Select-Object Name, AdapterRAM, DriverVersion

# ---------- Collect: Disks / Volumes ----------
$disks   = Get-CimInstance Win32_DiskDrive | Select-Object Index,Model,SerialNumber,Size,InterfaceType,MediaType
$vols    = Get-Volume | Select-Object DriveLetter, FileSystem, FileSystemLabel, Size, SizeRemaining, HealthStatus

# ---------- Collect: Network ----------
$adapters = Get-NetAdapter | Select-Object Name, InterfaceDescription, Status, MacAddress, LinkSpeed
$ipv4     = Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias,IPAddress,PrefixLength
$wifi     = @()
try {
  $wifi = netsh wlan show interfaces | Out-String
} catch {}

# ---------- Collect: BitLocker (if admin) ----------
$bitlocker = @()
if (Test-Admin) {
  try {
    $bitlocker = Get-BitLockerVolume | Select-Object MountPoint, VolumeType, ProtectionStatus, EncryptionPercentage, KeyProtector
  } catch {
    $bitlocker = @("BitLocker cmdlets not available")
  }
} else {
  $bitlocker = @("Run PowerShell as Administrator to collect BitLocker status.")
}

# ---------- Collect: Installed Software ----------
# 64-bit + 32-bit uninstall keys
$uninstPaths = @(
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
  "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
$apps = foreach ($p in $uninstPaths) {
  Get-ItemProperty -Path $p -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName } |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
} | Sort-Object DisplayName -Unique

# ---------- Collect: Local Users ----------
$localUsers = try {
  Get-LocalUser | Select-Object Name, Enabled, LastLogon
} catch { @() }

# ---------- Build Object ----------
$inv = [ordered]@{
  InventoryVersion = "1.0"
  CollectedAt      = (Get-Date).ToString("o")
  Hostname         = $hostname
  Domain           = $cs.Domain
  Manufacturer     = $cs.Manufacturer
  Model            = $cs.Model
  SerialNumber     = $bios.SerialNumber
  OS               = @{
    Caption        = $os.Caption
    Version        = $os.Version
    BuildNumber    = $os.BuildNumber
    InstallDate    = $os.InstallDate
    LastBootUpTime = $os.LastBootUpTime
  }
  CPU              = $cpu | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed
  Memory           = $mem
  GPU              = $gpu
  Disks            = $disks
  Volumes          = $vols
  NetworkAdapters  = $adapters
  IPv4             = $ipv4
  WifiRaw          = $wifi
  BitLocker        = $bitlocker
  InstalledApps    = $apps
  LocalUsers       = $localUsers
}

# ---------- Write JSON ----------
$inv | ConvertTo-Json -Depth 6 | Out-File -FilePath $jsonPath -Encoding UTF8

# ---------- Write concise CSV (one row summary) ----------
$csvRow = [pscustomobject]@{
  CollectedAt       = (Get-Date)
  Hostname          = $hostname
  Manufacturer      = $cs.Manufacturer
  Model             = $cs.Model
  SerialNumber      = $bios.SerialNumber
  OS                = $os.Caption
  OSBuild           = $os.BuildNumber
  CPU               = $cpu.Name
  Cores             = $cpu.NumberOfCores
  LogicalProcessors = $cpu.NumberOfLogicalProcessors
  RAM_GB            = [Math]::Round(($os.TotalVisibleMemorySize/1MB),2)
  DiskCount         = ($disks | Measure-Object).Count
  TotalDisk_GB      = [Math]::Round(($disks | Measure-Object -Property Size -Sum).Sum/1GB,2)
  IPv4              = ($ipv4.IPAddress -join ";")
  BitLockerStatus   = if ($bitlocker -is [array]) { ($bitlocker | ForEach-Object { $_.ProtectionStatus }) -join ";" } else { $bitlocker }
  AppCount          = ($apps | Measure-Object).Count
}
$csvRow | Export-Csv -NoTypeInformation -Path $csvPath

Write-Host "Inventory written to:" -ForegroundColor Cyan
Write-Host "  JSON: $jsonPath"
Write-Host "  CSV : $csvPath"

# ---------- Optional: Upload to Azure Blob via SAS ----------
function Upload-WithSAS {
  param([string]$LocalPath, [string]$SasUrl)
  try {
    # Build target blob URL by appending filename (handles container or virtual dir SAS)
    $uri = [System.Uri]$SasUrl
    $sep = $uri.AbsolutePath.EndsWith('/') ? "" : "/"
    $target = "{0}://{1}{2}{3}{4}{5}" -f $uri.Scheme, $uri.Host, $uri.AbsolutePath, $sep, [System.IO.Path]::GetFileName($LocalPath), $uri.Query
    Invoke-WebRequest -Uri $target -Method Put -InFile $LocalPath -Headers @{ "x-ms-blob-type"="BlockBlob" } -UseBasicParsing | Out-Null
    Write-Host "Uploaded -> $target" -ForegroundColor Green
  } catch {
    Write-Warning "Upload failed for $LocalPath : $($_.Exception.Message)"
  }
}

if ($SasUrl) {
  Upload-WithSAS -LocalPath $jsonPath -SasUrl $SasUrl
  Upload-WithSAS -LocalPath $csvPath  -SasUrl $SasUrl
}
