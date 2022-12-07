<#
.SYNOPSIS
  Authenticate in Azure to return Azure DevOps Agents status to restart containers when no jobs are running.
.DESCRIPTION
  Authenticate in Azure to return Azure DevOps Agents status to restart containers when no jobs are running.
  PoolIds must match with correct region to work.
.NOTES
  Version:          1.0
  Purpose/Change:   Initial script development
  Requirements:     PowerShell 7
  Purpose:          Automation
#>

[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $appId,

    [Parameter()]
    [string]
    $secretId,

    [Parameter()]
    [string]
    $subscriptionId,

    [Parameter()]
    [string]
    $tenantId,

    [Parameter()]
    [string]
    $azdoUrl,

    [Parameter()]
    [string]
    $azdoToken
)

$env:AZURE_DEVOPS_EXT_PAT = $azdoToken

# ----------------------------------------------
# Azure Authentication
# ----------------------------------------------

try {
    Write-Host "##[section] Login to Azure Portal..."
    az login --service-principal -u $appId -p $secretId --tenant $tenantId
    az account set -s $subscriptionId
    Write-Host "##[section] Login to Azure DevOps..."
    Write-Host "##[section] Using $azdoUrl"
    az devops configure --defaults organization=$azdoUrl
}
catch {
    Write-Warning "##[error] Azure Authentication Failed"
}

# --------------------------------------------------------------
# Get Agent Status and restart containers when no jobs running
# --------------------------------------------------------------
    
$poolIds = @{
    "12" = "centralus"
    "13" = "eastus2"
    "14" = "centralindia"
}
    
$poolIds.keys | ForEach-Object {
    
    $list = (az pipelines agent list --include-assigned-request --pool-id $_ --query "[].assignedRequest")
    
    while ($list -ne "[]") {
        Write-Host "##[section] The pool in $($poolIds[$_]) still running jobs, retrying in 10 seconds..."
        Start-Sleep 10
        $list = (az pipelines agent list --include-assigned-request --pool-id $_ --query "[].assignedRequest")
    }
    
    $aciList = (az container list --query "[?location == '$($poolIds[$_])'].name" --output tsv)
    
    $aciList | ForEach-Object {
        $rg = (az container list --query "[?name == '$_'].resourceGroup" --output tsv)
        $location = (az container list --query "[?name == '$_'].location" --output tsv)
        Write-Host "##[section] Starting container restart in $location"
        az container restart -n $_ -g $rg --no-wait
    }
}