subscription_id = "5a1019fa-917d-4ca0-8580-52ff2469e621"

location         = "centralus"
location_code    = "cu"
environment_code = "prod"

function_name = "dvp"
purpose_name  = "ado"

virtual_network = {
  name           = "vnet-dvp-prod-cu-56kt"
  resource_group = "rg-dvp-prod-cu-vnet-at56"
  subnet         = "snet-dvp-prod-cu-aci-1jf4"
}

windows_container_config = {
  default = {
    ip_address_type = "Private"
    containers = {
      default = {
        name   = "windowsagent"
        image  = "latest"
        cpu    = "2"
        memory = "7"
        ports = {
          default = {
            port     = 443
            protocol = "TCP"
          }
        }
      }
    }
    azdo_url             = "#{tf-azdo-url}#"
    azdo_pat_token       = "#{tf-azdo-pat}#"
    azdo_agent_pool_name = "#{AZP_POOL_WINDOWS_CU_DEV}#"
    azdo_number_of_agents = #{AZP_NUMBER_OF_WINDOWS_AGENTS_CU_DEV}#
  }
}

remote_state_acr = {
  storage_account_name = "#{tf-state-blob-global-account}#"
  container_name       = "#{tf-state-blob-container}#"
  key                  = "#{tf-state-blob-file-acr-cu}#"
  access_key           = "#{tf-state-blob-global-access-key}#"
}
