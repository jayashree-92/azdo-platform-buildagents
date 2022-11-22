subscription_id = "5a1019fa-917d-4ca0-8580-52ff2469e621"

location         = "centralindia"
location_code    = "ci"
environment_code = "prod"

function_name = "dvp"
purpose_name  = "ado"

virtual_network = {
  name           = "vnet-dvp-prod-ci-44wb"
  resource_group = "rg-dvp-prod-ci-vnet-43bv"
  subnet         = "snet-dvp-prod-ci-aci-8u0g"
}

linux_container_config = {
  default = {
    ip_address_type = "Private"
    dns_config = {
      search_domains = ["innocap.com"]
      nameservers    = ["10.70.0.132"]
    }
    containers = {
      default = {
        name   = "linuxagent"
        image  = "latest"
        cpu    = "2"
        memory = "4"
        ports = {
          default = {
            port     = 443
            protocol = "TCP"
          }
        }
      }
    }
    azdo_url              = "#{AZP_URL}#"
    azdo_pat_token        = "#{AZP_TOKEN}#"
    azdo_agent_pool_name  = "#{AZP_POOL_CI}#"
    azdo_number_of_agents = #{AZP_NUMBER_OF_LINUX_AGENTS_CI}#
  }
}

remote_state_acr = {
  storage_account_name = "#{tf-state-blob-account}#"
  container_name       = "#{tf-state-blob-container}#"
  key                  = "#{tf-state-blob-file-acr-ci}#"
  access_key           = "#{tf-state-blob-access-key}#"
}
