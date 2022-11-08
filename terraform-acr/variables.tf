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

variable "acr" {
  description = "Azure Container Registry"
  type = object({
    sku = string
  })
}
