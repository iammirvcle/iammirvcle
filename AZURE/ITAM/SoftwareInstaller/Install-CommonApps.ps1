<# 
 Automated Software Installer (winget)
 Installs a curated set of common IT tools silently via winget.
 Supports profiles: minimal | standard | dev
#>

[CmdletBinding()]
param(
    [ValidateSet("minimal","standard","dev")]
    [string]$Profile = "standard"
)

$OutDir = Join-Path $PSScriptRoot "output"
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
$Log = Join-Path $OutDir "install-log.txt"

function Write-Log {
    param([string]$Message)
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    $line | Tee-Object -FilePath $Log -Append
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Log "ERROR: winget not found. Install Microsoft App Installer from the Store."
    throw "winget not found"
}

$Catalog = @{
    "7zip.7zip"                      = "7-Zip"
    "Google.Chrome"                  = "Google Chrome"
    "Mozilla.Firefox"                = "Mozilla Firefox"
    "Microsoft.PowerShell"           = "PowerShell 7"
    "Microsoft.VisualStudioCode"     = "Visual Studio Code"
    "Notepad++.Notepad++"            = "Notepad++"
    "Git.Git"                        = "Git"
    "VideoLAN.VLC"                   = "VLC"
    "Microsoft.PowerToys"            = "PowerToys"
    "WiresharkFoundation.Wireshark"  = "Wireshark"
    "PuTTY.PuTTY"                    = "PuTTY"
    "WinSCP.WinSCP"                  = "WinSCP"
    "Microsoft.AzureCLI"             = "Azure CLI"
    "Docker.DockerDesktop"           = "Docker Desktop"
    "Postman.Postman"                = "Postman"
}

$Profiles = @{
    "minimal" = @("7zip.7zip","Google.Chrome","Microsoft.VisualStudioCode")
    "standard" = @("7zip.7zip","Google.Chrome","Microsoft.VisualStudioCode","Notepad++.Notepad++","Git.Git","VideoLAN.VLC","Microsoft.PowerToys")
    "dev" = @("7zip.7zip","Google.Chrome","Microsoft.VisualStudioCode","Notepad++.Notepad++","Git.Git","VideoLAN.VLC","Microsoft.PowerToys","WiresharkFoundation.Wireshark","PuTTY.PuTTY","WinSCP.WinSCP","Microsoft.AzureCLI","Docker.DockerDesktop","Postman.Postman")
}

$TargetApps = $Profiles[$Profile]
Write-Log "=== Automated Installer started (profile: $Profile) ==="

function Test-AppInstalled {
    param([string]$WingetId)
    $res = winget list --id $WingetId --accept-source-agreements 2>$null
    return ($LASTEXITCODE -eq 0 -and $res -match $WingetId)
}

function Install-App {
    param([string]$WingetId)

    $name = $Catalog[$WingetId]
    if (Test-AppInstalled -WingetId $WingetId) {
        Write-Log "SKIP: $name ($WingetId) already installed."
        return
    }

    Write-Log "INSTALL: $name ($WingetId) ..."
    winget install --id $WingetId `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements `
        --disable-interactivity

    if ($LASTEXITCODE -eq 0) {
        Write-Log "SUCCESS: $name installed."
    } else {
        Write-Log "ERROR: Failed to install $name (code $LASTEXITCODE)."
    }
}

foreach ($app in $TargetApps) {
    if (-not $Catalog.ContainsKey($app)) {
        Write-Log "WARN: App id '$app' not found in catalog."
        continue
    }
    Install-App -WingetId $app
}

Write-Log "=== Completed. Log: $Log ==="
Write-Host "`nDone. See log file at: $Log"
