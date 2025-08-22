<# 
 PC Asset Inventory Script
 Outputs a single CSV row with basic hardware/software details.
#>

$os   = Get-CimInstance Win32_OperatingSystem
$cs   = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_BIOS
$cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

# Sum total/free disk GB (rounded)
$diskTotalGB = [math]::Round(($disks | Measure-Object -Property Size -Sum).Sum / 1GB, 2)
$diskFreeGB  = [math]::Round(($disks | Measure-Object -Property FreeSpace -Sum).Sum / 1GB, 2)

# Optional: quick count of installed software (fast, registry-based)
$apps64 = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue
$apps32 = Get-ItemProperty -Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue
$installedAppCount = ($apps64 + $apps32 | Where-Object { $_.DisplayName }) .Count

# Basic network (first active IPv4)
$ip = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -ErrorAction SilentlyContinue | Where-Object {$_.IPAddress -notmatch "^169\."} | Select-Object -First 1).IPAddress
if (-not $ip) { $ip = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Select-Object -First 1).IPAddress }

# Build the record
$record = [pscustomobject]@{
    Timestamp           = (Get-Date).ToString("s")
    ComputerName        = $env:COMPUTERNAME
    Manufacturer        = $cs.Manufacturer
    Model               = $cs.Model
    SerialNumber        = $bios.SerialNumber
    OS                  = "$($os.Caption) $($os.Version)"
    OSBuild             = $os.BuildNumber
    CPU                 = $cpu.Name
    Cores               = $cpu.NumberOfCores
    LogicalProcessors   = $cpu.NumberOfLogicalProcessors
    RAM_GB              = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
    Disk_Total_GB       = $diskTotalGB
    Disk_Free_GB        = $diskFreeGB
    IPAddress           = $ip
    InstalledApps_Count = $installedAppCount
    UserName            = $cs.UserName
}

# Output to CSV (append if exists)
$outDir = "$PSScriptRoot\output"
$outFile = Join-Path $outDir "asset-inventory.csv"
if (-not (Test-Path $outDir)) { New-Item -Path $outDir -ItemType Directory | Out-Null }

$exists = Test-Path $outFile
$record | Export-Csv -Path $outFile -NoTypeInformation -Append:($exists)
Write-Host "Inventory captured to $outFile"

