param([string]$TenantName)
param([string]$M365LPSiteUrl)

# verify the PnP cmdlets we need are installed
if (Get-Command Get-PnPStoredCredentiaal -ErrorAction SilentlyContinue  ) {
  Write-Host "Could not find PnP PowerShell cmdlets"
  Write-Host "Please install them and run this script again"
  Write-Host "You can install them with the following line:"
  Write-Host "`nInstall-Module SharePointPnPPowerShellOnline`n"
  break
} 

# Check if tenant name was passed in
if ([string]::IsNullOrWhitespace($TenantName)) {
  # No TenantName was passed, prompt the user
  $TenantName = Read-Host "Please enter your tenant name: (contoso) "
}
$AdminURL = "https://$TenantName.sharepoint.com"

# Check if M365 LP Site Url was passed in
if ([string]::IsNullOrWhitespace($M365LPSiteUrl)) {
  # No Site Collection URL was passed, prompt the user
  $M365LPSiteUrl = Read-Host "Please enter the URL of your Microsoft 365 learning pathways site collection: ($AdminURL/sites/M365LP)"
}

# Connect to Admin site.
# Todo: Differentiate between valid $adminurl and authentication error (bad password or no access)
try {
  Connect-PnPOnline -Url $AdminURL -UseWebLogin
}
catch {
  Write-Host "Failed to authenticate to $AdminURL"
  Write-Host $_
  break
}

Set-PnPStorageEntity -Key MicrosoftCustomLearningSite -Value $M365LPSiteUrl -Description "Microsoft 365 learning pathways Site Collection"
Get-PnPStorageEntity -Key MicrosoftCustomLearningSite