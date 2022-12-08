<#
.SYNOPSIS
  Azure Container Registry Cleanup

.DESCRIPTION
  Login to Azure Container Registry and clean all images in the repositories older than the the specified number of days

.NOTES
  Version:          1.0
  Purpose/Change:   Initial script development
  Requirements:     AzureCLI
  Purpose:          Automation (Can still be executed manually)
#>

[CmdletBinding()]
Param(
    # Define Service Prinicipal Name for Azure authentication
    [Parameter(Mandatory=$true)]
    [String] $appId,
    
    # Define Service Prinicial key for Azure authentication
    [Parameter(Mandatory=$true)]
    [String] $appSecret,

    # Define Tenant ID for Azure authentication
    [Parameter (Mandatory=$true)]
    [String] $tenantId,

    # Define Azure Subscription Name
    [Parameter (Mandatory=$true)]
    [String] $subscriptionId,
 
    # Define ACR Name
    [Parameter (Mandatory=$true)]
    [String] $acrName,
 
    # Gets no of days from user; images older than this will be removed
    [Parameter (Mandatory=$false)]
    [String] $days = "180",

    # Gets no of images to keep from user; images older than this will be removed
    [Parameter (Mandatory=$false)]
    [String] $keptImages,

    # Allow the user to see what the script would have done, without actually deleting anything
    [Parameter (Mandatory=$false)]
    [bool] $dryRun = $false
)

$ErrorActionPreference = "Stop"

# ----------------------------------------------
# ACR Cleanup Function
# ----------------------------------------------
Function Remove-Image {
    param(
    [Parameter(Mandatory=$true)]
    [string] $registryName,

    [Parameter(Mandatory=$true)]
    [string] $imageName,

    [Parameter(Mandatory=$false)]
    [bool] $dryRun=$false
    )

    if($dryRun){
        Write-Host "##[warning] Would have deleted $imageName"
    }
    else {
        Write-Host "##[section] Proceeding to delete image: $imageName"
        az acr repository delete --name $registryName --image $imageName --yes
    }
}

# ----------------------------------------------
# Azure Authentication
# ----------------------------------------------

try {
    Write-Host "##[section] Login to Azure Portal..."
    az login --service-principal -u $appId -p $appSecret --tenant $tenantId
    az account set -s $subscriptionId
}
catch {
    Write-Warning "##[error] Azure Authentication Failed"
}

# ----------------------------------------------
# ACR Cleanup Process
# ----------------------------------------------

Write-Host "##[section] Checking Azure Container Registry: $acrName"
$RepoList = az acr repository list --name $acrName --output table
for($index=2; $index -lt $RepoList.length; $index++){
    $RepositoryName = $RepoList[$index]

    Write-Host "##[section] Checking for repository: $RepositoryName"
    $RepositoryTags = az acr repository show-tags --name $acrName --repository $RepositoryName --orderby time_desc --output tsv

    # ----------------------------------------------------------------------------------------------------------
    # Delete by count if user specified a $keptImages
    # ----------------------------------------------------------------------------------------------------------
    if ($keptImages -gt 0){
        #since the list is ordered, delete the last X items
        foreach($tag in $RepositoryTags){
            if($RepositoryTags.IndexOf($tag) -ge $keptImages){
                $ImageName = $RepositoryName + ":" + $tag
                Remove-Image -registryName $acrName -imageName $ImageName -dryRun $dryRun
            }
        }
    }
    # ----------------------------------------------------------------------------------------------------------
    # Delete by the age of the label (assuming yyyyMMdd convention in the tag names)
    # ----------------------------------------------------------------------------------------------------------
    else {
        foreach($tag in $RepositoryTags){
            $RepositoryTagName = $tag.ToString().Split('_')        

            $RepositoryTagBuildDay = $RepositoryTagName[-1].ToString().Split('.')[0]
            if($RepositoryTagBuildDay -eq "latest"){
                Write-Host "##[warning] Skipping image: $RepositoryName/latest"
                continue;
            }

            $RepositoryTagBuildDay = [datetime]::ParseExact($repositorytagbuildday,'yyyyMMdd', $null)
            $ImageName = $RepositoryName + ":" + $tag

            if($RepositoryTagBuildDay -lt $((Get-Date).AddDays(-$days))){
                Remove-Image -registryName $acrName -imageName $imageName -dryRun $dryRun
            }        
            else{
                Write-Host "##[section] Skipping image: $imageName"
            }
        }
    }
}
