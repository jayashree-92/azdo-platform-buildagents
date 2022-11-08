locals {
  full_env_code  = format("%s-%s", var.environment_code, var.location_code)
  short_env_code = format("%s-%s", substr(var.environment_code, 0, 1), var.location_code)

  default_linux_container_config = lookup(var.linux_container_config, "default")
}