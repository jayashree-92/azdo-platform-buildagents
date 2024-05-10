subscription_id = "5a1019fa-917d-4ca0-8580-52ff2469e621"

location         = "eastus2"
location_code    = "eu"
environment_code = "prod"

function_name = "dvp"
purpose_name  = "ado"

virtual_network = {
  name           = "vnet-dvp-dr-eu-4m3e"
  resource_group = "rg-dvp-dr-eu-vnet-e82h"
  subnet         = "snet-dvp-dr-eu-aci-32gh"
}

linux_container_config = {
  default = {
    ip_address_type = "Private"
    dns_config = {
      search_domains = ["innocap.com"]
      nameservers    = ["10.60.0.132"]
    }
    containers = {
      default = {
        name   = "linuxagent"
        image  = "latest"
        cpu    = "1"
        memory = "2"
        ports = {
          default = {
            port     = 443
            protocol = "TCP"
          }
        }
      }
    }
    azdo_url              = "#{tf-azdo-url}#"
    azdo_pat_token        = "#{tf-azdo-pat}#"
    azdo_agent_pool_name  = "#{AZP_POOL_EU}#"
    azdo_number_of_agents = #{AZP_NUMBER_OF_LINUX_AGENTS_EU}#
  }
}

remote_state_acr = {
  storage_account_name = "#{tf-state-blob-global-account}#"
  container_name       = "#{tf-state-blob-container}#"
  key                  = "#{tf-state-blob-file-acr-eu}#"
  access_key           = "#{tf-state-blob-global-access-key}#"
}