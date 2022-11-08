#---------------------------------------------------------
# Generates Random String for resources naming
#---------------------------------------------------------
resource "random_string" "unique_4" {
  length      = 4
  special     = false
  upper       = false
  min_numeric = 2
}

#---------------------------------------------------------
# ACI from module
#---------------------------------------------------------
module "aci-linux" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-container-group//?ref=v1.0.0"
  count  = local.default_linux_container_config.azdo_number_of_agents

  function_name       = var.function_name
  purpose_name        = var.purpose_name
  resource_group_name = module.rg-dockeragents.name
  location            = var.location
  location_code       = var.location_code
  environment_code    = var.environment_code
  ip_address_type     = local.default_linux_container_config.ip_address_type
  os_type             = "Linux"
  subnet_ids          = [data.azurerm_subnet.snet.id]

  image_registry_credential_username = data.azurerm_container_registry.acr.admin_username
  image_registry_credential_password = data.azurerm_container_registry.acr.admin_password
  image_registry_credential_server   = data.azurerm_container_registry.acr.login_server

  containers = [
    {
      name   = local.default_linux_container_config.containers.default.name
      image  = "${data.azurerm_container_registry.acr.login_server}/${local.default_linux_container_config.containers.default.name}:${local.default_linux_container_config.containers.default.image}"
      cpu    = local.default_linux_container_config.containers.default.cpu
      memory = local.default_linux_container_config.containers.default.memory

      ports = [
        {
          port     = local.default_linux_container_config.containers.default.ports.default.port
          protocol = local.default_linux_container_config.containers.default.ports.default.protocol
        }
      ]

      secure_environment_variables = {
        "AZP_URL"        = local.default_linux_container_config.azdo_url
        "AZP_TOKEN"      = local.default_linux_container_config.azdo_pat_token
        "AZP_AGENT_NAME" = format("linuxagent-%s-%s", local.full_env_code, count.index)
        "AZP_POOL"       = local.default_linux_container_config.azdo_agent_pool_name
      }
    }
  ]
}
