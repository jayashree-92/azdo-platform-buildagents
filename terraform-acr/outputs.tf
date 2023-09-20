# output "acr_name" {
#   value = module.acr.container_registry_name
# }

# output "acr_resource_group_name" {
#   value = module.acr.container_registry_resource_group_name
# }

output "acr" {
  value = { for k, v in module.acr : k => {
    "container_registry_name"                = v.container_registry_name
    "container_registry_resource_group_name" = v.container_registry_resource_group_name
  } }
}
