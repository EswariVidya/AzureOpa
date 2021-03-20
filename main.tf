provider "azurerm" {
    features{}
}

terraform {
    backend "azurerm" {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "teststorageaccount1" {
  name                      = format("staccount%s", random_string.name.result)
  resource_group_name       = var.resource_gp_name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = false
  allow_blob_public_access  = true
}

resource "azurerm_storage_container" "testcontainer" {
  name                    = format("stcontainer%s", random_string.name.result)
  storage_account_name    = azurerm_storage_account.teststorageaccount1.name
  container_access_type   = "blob"
}
