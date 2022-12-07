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
    $tenantId,

    [Parameter()]
    [string]
    $azdoUrl,

    [Parameter()]
    [string]
    $azdoToken
)

# ----------------------------------------------
# Azure Authentication
# ----------------------------------------------

try {
    Write-Host "Login to Azure..."
    az login --service-principal -u $appId -p $secretId --tenant $tenantId
    Write-Host "Login to Azure DevOps..."
    Write-Output $azdoToken | az devops login --organization $azdoUrl
    az devops configure --defaults organization=$azdoUrl
}
catch {
    Write-Warning "Azure Authentication Failed"
}

$poolIds = @{
    "12" = "centralus"
    "13" = "eastus2"
    "14" = "centralindia"
}

# --------------------------------------------------------------
# Get Agent Status and restart containers when no jobs running
# --------------------------------------------------------------

$poolIds.keys | ForEach-Object {

    $list = (az pipelines agent list --include-assigned-request --pool-id $_ --query "[].assignedRequest")

    while ($list -ne "[]") {
        Write-Host "The pool in $($poolIds[$_]) still running jobs, retrying in 10 seconds..."
        Start-Sleep 10
        $list = (az pipelines agent list --include-assigned-request --pool-id $_ --query "[].assignedRequest")
    }

    $aciList = (az container list --query "[?location == '$($poolIds[$_])'].name" --output tsv)

    $aciList | ForEach-Object {
        $rg = (az container list --query "[?name == '$_'].resourceGroup" --output tsv)
        az container restart -n $_ -g $rg --no-wait
    }
}