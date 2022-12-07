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

$env:AZURE_DEVOPS_EXT_PAT = $azdoToken



try {
    # ----------------------------------------------
    # Azure Authentication
    # ----------------------------------------------

    Write-Host "Login to Azure..." -ForegroundColor Green
    az login --service-principal -u $appId -p $secretId --tenant $tenantId
    Write-Host "Login to Azure DevOps..." -ForegroundColor Green
    Write-Host "Using $azdoUrl" -ForegroundColor Green
    az devops configure --defaults organization=$azdoUrl
    
    # --------------------------------------------------------------
    # Get Agent Status and restart containers when no jobs running
    # --------------------------------------------------------------
    
    Write-Host "Starting container restart..." -ForegroundColor Green

    $poolIds = @{
        "12" = "centralus"
        "13" = "eastus2"
        "14" = "centralindia"
    }

    # test temp
    az pipelines agent list --include-assigned-request --pool-id 12 --query "[].assignedRequest"
    
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
}
catch {
    Write-Warning "Azure Authentication Failed"
}