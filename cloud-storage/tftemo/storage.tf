resource "random_string" "extension" {
  length      = 6
  special     = false
  upper       = false
  lower       = true
  min_numeric = 4
}

locals {
  staccname = "bcwssdemo${random_string.extension.result}"
}

resource "azurerm_resource_group" "static_site_demo" {
  name     = "${var.rg_name}"
  location = "West US 2"
}

resource "azurerm_storage_account" "static_site_acc" {
  name                     = local.staccname
  resource_group_name      = azurerm_resource_group.static_site_demo.name
  location                 = azurerm_resource_group.static_site_demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"

  }
}