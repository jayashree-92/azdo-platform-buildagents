variable "linux_container_config" {
  description = "Linux Container Group Configuration"
  type        = map(any)
  default     = {}
}

variable "windows_container_config" {
  description = "Windows Container Group Configuration"
  type        = map(any)
  default     = {}
}

variable "virtual_network" {
  description = "Virtual Network and Subnet"
  type = object({
    name           = string
    resource_group = string
    subnet         = string
  })
}

variable "remote_state_acr" {
  description = "Remote State to fetch ACR data"
  type = object({
    storage_account_name = string
    container_name       = string
    key                  = string
    access_key           = string
  })
}

variable "location" {
  description = "Azure resources location"
  type        = string
}

variable "environment_code" {
  description = "Environment code for naming convention"
  type        = string
}

variable "location_code" {
  description = "Location code for naming convention"
  type        = string
}

variable "subscription_id" {
  description = "Target Azure Subscription"
  type        = string
}

variable "purpose_name" {
  description = "Purpose name for naming convention"
  type        = string
}

variable "function_name" {
  description = "Function name for naming convention"
  type        = string
}
