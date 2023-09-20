global_settings = {
  environment_code = "prod"
  function         = "dvp"
  location         = "centralindia"
  location_code    = "ci"
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