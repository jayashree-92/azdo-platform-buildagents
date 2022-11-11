#---------------------------------------------------------
# ACR from module
#---------------------------------------------------------
module "acr" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-container-registry//module//?ref=v1.0.0"

  function_name       = var.function_name
  purpose_name        = var.purpose_name
  resource_group_name = module.rg-dockeragents.name
  location            = var.location
  location_code       = var.location_code
  environment_code    = var.environment_code
  sku                 = var.acr.sku
  admin_enabled       = true

  depends_on = [
    module.rg-dockeragents
  ]
}
