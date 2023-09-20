module "acr" {
  source   = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-container-registry//module//?ref=v1.0.0"
  for_each = var.container_registries

  purpose_name        = each.value.purpose
  resource_group_name = module.resource_groups[each.value.resource_group_key].name

  function_name       = local.global_settings.function
  location            = local.global_settings.location
  location_code       = local.global_settings.location_code
  environment_code    = local.global_settings.environment_code
  sku                 = try(each.value.sku, "Basic")
  admin_enabled       = try(each.value.admin_enabled, true)

  depends_on = [
    module.resource_groups
  ]
}
