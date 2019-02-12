variable "subscription_id" {
  description = "The Azure subscription ID"
  default     = "subscription_id"
}

variable "tenant_id" {
  description = "The Azure tenant ID"
  default     = "tenant_id"
}

variable "client_id" {
  description = "The Azure client ID"
  default     = "client_id"
}
variable "secret_access_key" {
  description = "The Azure secret access key"
  default     = "secret_access_key"
}
variable "resource_group_name" {
  description = "The name of the Azure resource group consul will be deployed into. This RG should already exist"
  default     = "vault-consul-cluster"
}
variable "storage_account_name" {
  description = "The name of an Azure Storage Account. This SA should already exist"
  default     = "hashistorageaccount"
}
variable "location" {
  description = "The Azure region the consul cluster will be deployed in"
  default = "West US"
}
