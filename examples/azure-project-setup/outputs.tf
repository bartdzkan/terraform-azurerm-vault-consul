output "storage_account_name" {
  value = "${var.storage_account_name}"
}
output "vault-consul-storage-account" {
  value = "${azurerm_storage_account.vault-consul-storage-account.primary_access_key}"
}
