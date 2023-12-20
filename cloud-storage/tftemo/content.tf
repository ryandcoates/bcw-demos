resource "azurerm_storage_blob" "index_file" {
  name                   = "index.html"
  content_md5            = filemd5("src/index.html")
  storage_account_name   = azurerm_storage_account.static_site_acc.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "src/index.html"
}

resource "azurerm_storage_blob" "notfound_file" {
  name                   = "404.html"
  content_md5            = filemd5("src/404.html")
  storage_account_name   = azurerm_storage_account.static_site_acc.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "src/404.html"
}