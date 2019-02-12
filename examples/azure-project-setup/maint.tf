provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.secret_access_key}"
  tenant_id = "${var.tenant_id}"
}


resource "azurerm_resource_group" "vault-consul-resource_group" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

}

resource "azurerm_storage_account" "vault-consul-storage-account" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "LRS"

  depends_on = ["azurerm_resource_group.vault-consul-resource_group"]

}
