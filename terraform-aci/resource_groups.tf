module "rg-dockeragents" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-resource-group//?ref=v1.0.2"

  function_name      = var.function_name
  purpose_name       = var.purpose_name
  environment_code   = var.environment_code
  location_code      = var.location_code
  location           = var.location
  create             = true
  enable_delete_lock = false
}
