global_settings = {
  environment_code = "prod"
  function         = "dvp"
  location         = "eastus2"
  location_code    = "eu"
}

resource_groups = {
   ado = { purpose = "ado" }
}

container_registries = {
    ado = {
    purpose            = "ado"
    resource_group_key = "ado"
  }
}


