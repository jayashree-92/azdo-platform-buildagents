global_settings = {
  environment_code = "prod"
  function         = "dvp"
  location         = "centralus"
  location_code    = "cu"
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