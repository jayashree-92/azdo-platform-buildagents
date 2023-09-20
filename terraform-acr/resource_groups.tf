module "resource_groups" {
  source   = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-resource-group//module//?ref=v2.1.0"
  for_each = var.resource_groups

  purpose_name       = each.value.purpose
  environment_code   = local.global_settings.environment_code
  function_name      = local.global_settings.function
  location_code      = local.global_settings.location_code
  location           = local.global_settings.location
  create             = try(each.value.create, true)
  enable_delete_lock = try(each.value.enable_delete_lock, false)
  tags = local.tags
}
