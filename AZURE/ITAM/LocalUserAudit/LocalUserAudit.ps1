<# 
 Local User Account Audit
 Creates a CSV of local users + flags (Disabled, Admin, Inactive>90d), and a Findings.txt summary.
 Requires PowerShell 5+ (Windows 10/11).
#>

# Helper: days since last logon (Get-LocalUser.LastLogon may be $null)
function Get-LastLogonDays($user) {
    if ($user.LastLogon) {
        return (New-TimeSpan -Start $user.LastLogon -End (Get-Date)).Days
    } else {
        return $null
    }
}

$users = Get-LocalUser
$adminMembers = @()
try {
    $adminMembers = (Get-LocalGroupMember -Group "Administrators" -ErrorAction Stop).Name
} catch {
    # Fallback for older systems
    $adminMembers = (net localgroup administrators) 2>$null | Select-String -Pattern "^\S" | ForEach-Object { $_.ToString().Trim() }
}

$records = foreach ($u in $users) {
    $days = Get-LastLogonDays $u
    [pscustomobject]@{
        UserName              = $u.Name
        Enabled               = $u.Enabled
        Description           = $u.Description
        PasswordNeverExpires  = $u.PasswordNeverExpires
        UserMayChangePassword = $u.UserMayChangePassword
        LastLogon             = if ($u.LastLogon) { $u.LastLogon.ToString("s") } else { "" }
        LastLogonDays         = $days
        InactiveOver90Days    = if ($days -ne $null) { $days -gt 90 } else { $true } # treat never-logged-in as inactive
        IsAdministrator       = $adminMembers -contains $u.Name -or ($adminMembers | Where-Object { $_ -match [regex]::Escape($u.Name) })
        AccountExpires        = if ($u.AccountExpires -and $u.AccountExpires -gt 0) { 
                                    ([DateTime]::FromFileTimeUtc($u.AccountExpires)).ToString("s") 
                                } else { "" }
    }
}

# Output
$outDir = "$PSScriptRoot\output"
if (-not (Test-Path $outDir)) { New-Item -Path $outDir -ItemType Directory | Out-Null }
$csvPath = Join-Path $outDir "local-users-audit.csv"
$txtPath = Join-Path $outDir "Findings.txt"

$records | Sort-Object UserName | Export-Csv -NoTypeInformation -Path $csvPath

# Summary
$disabled = ($records | Where-Object { -not $_.Enabled }).Count
$admins   = ($records | Where-Object { $_.IsAdministrator }).Count
$inactive = ($records | Where-Object { $_.InactiveOver90Days }).Count

@"
Local User Audit Summary - $(Get-Date -Format s)

Total accounts: $($records.Count)
Disabled:       $disabled
Administrators: $admins
Inactive >90d:  $inactive

See CSV for details: $csvPath
"@ | Out-File -FilePath $txtPath -Encoding UTF8

Write-Host "Audit complete:`n- $csvPath`n- $txtPath"
