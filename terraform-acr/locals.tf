locals {
  full_env_code  = format("%s-%s", local.global_settings.environment_code, local.global_settings.location_code)
  short_env_code = format("%s-%s", substr(local.global_settings.environment_code, 0, 1), local.global_settings.location_code)

  global_settings = merge({
    environment_code = try(var.global_settings.environment_code, "prod")
    function         = try(var.global_settings.function, "dvp")
    location         = try(var.global_settings.location, "centralus")
    location_code    = try(var.global_settings.location_code, "cu")
  }, var.global_settings)

  tags = merge({
    environment           = local.global_settings.environment_code
    component             = "ado"
    deployment_project    = "devops-platform-management"
    deployment_repository = "azdo-platform-build-agents"

  }, var.tags)
}
