variable "global_settings" {}

variable "container_registries" {
  default = {}
}

variable "resource_groups" {
  default = {}
}

variable "tags" {
  default = {}
}

variable "subscription_id" {
  description = "Target Azure Subscription"
  type        = string
}