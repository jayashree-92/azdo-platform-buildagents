# ------------------------------------
# Networking
# ------------------------------------
data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network.name
  resource_group_name = var.virtual_network.resource_group
}

data "azurerm_subnet" "snet" {
  name                 = var.virtual_network.subnet
  virtual_network_name = var.virtual_network.name
  resource_group_name  = var.virtual_network.resource_group
}

# ------------------------------------
# Azure Container Registry
# ------------------------------------
data "terraform_remote_state" "acr" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_acr.storage_account_name
    container_name       = var.remote_state_acr.container_name
    key                  = var.remote_state_acr.key
    access_key           = var.remote_state_acr.access_key
  }
}

data "azurerm_container_registry" "acr" {
  name                = data.terraform_remote_state.acr.outputs.acr.ado.container_registry_name
  resource_group_name = data.terraform_remote_state.acr.outputs.acr.ado.container_registry_resource_group_name
}
