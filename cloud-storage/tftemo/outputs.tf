output "storage_account_web_endpoint" {
  value = azurerm_storage_account.static_site_acc.primary_web_endpoint
}