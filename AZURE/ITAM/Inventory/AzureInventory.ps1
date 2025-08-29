<#  
.SYNOPSIS
  Enumerates Azure resources in a subscription or a specific Resource Group.

.EXAMPLE
  .\Get-AzureInventory.ps1 -ResourceGroup rg-free-tier-lab -OutDir .\cloudinv
#>

[CmdletBinding()]
param(
  [string]$ResourceGroup = "",
  [Parameter(Mandatory=$true)][string]$OutDir
)

if (-not (Get-Module -ListAvailable Az.Accounts)) { Install-Module Az -Scope CurrentUser -Force }
Import-Module Az.Accounts
Import-Module Az.Resources

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
$timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
$jsonPath  = Join-Path $OutDir "AzureInventory_$timestamp.json"
$csvPath   = Join-Path $OutDir "AzureInventory_$timestamp.csv"

try {
  if (-not (Get-AzContext)) { Connect-AzAccount -UseDeviceAuthentication | Out-Null }
} catch { Connect-AzAccount -UseDeviceAuthentication | Out-Null }

$resources = if ($ResourceGroup) {
  Get-AzResource -ResourceGroupName $ResourceGroup
} else {
  Get-AzResource
}

$rows = foreach ($r in $resources) {
  # Try to pull SKU if available
  $sku = $null
  try { $sku = (Get-AzResource -ResourceId $r.ResourceId -ExpandProperties).Sku.Name } catch {}

  [pscustomobject]@{
    Name          = $r.Name
    Type          = $r.ResourceType
    ResourceGroup = $r.ResourceGroupName
    Location      = $r.Location
    Sku           = $sku
    Kind          = $r.Kind
    Tags          = if ($r.Tags) { ($r.Tags.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ";" } else { "" }
    Id            = $r.ResourceId
  }
}

$rows | ConvertTo-Json -Depth 5 | Out-File -FilePath $jsonPath -Encoding UTF8
$rows | Export-Csv -NoTypeInformation -Path $csvPath

Write-Host "Azure inventory saved:" -ForegroundColor Cyan
Write-Host "  JSON: $jsonPath"
Write-Host "  CSV : $csvPath"
