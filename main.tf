provider "azurerm" {
    #version = "~>2.13.0"
    #subscription_id = var.subscription_id
    #tenant_id = var.tenant_id
    #client_id = var.client_id
    #client_secret = var.client_secret
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
resource "azurerm_sql_server" "newsqlserver" {
    name                         = format("sql%s", random_string.name.result)
    resource_group_name          = var.resource_gp_name
    location                     = var.location
    version                      = "12.0"
    administrator_login = format("admin%s", random_string.name.result)
    administrator_login_password = random_string.userPassword.result 
}

resource "azurerm_sql_firewall_rule" "invalidrule1" {
  name                = "invalidrule1"
  resource_group_name = var.resource_gp_name
  server_name         = azurerm_sql_server.newsqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "10.0.17.62"
}

resource "azurerm_network_security_group" "nsg" {
    name = format("nsg%s", random_string.name.result)
    location = var.location
    resource_group_name = var.resource_gp_name
    security_rule {
        name = "SSH"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "Internet"
        destination_address_prefix = "*"
      }
}

resource "azurerm_virtual_network" "vnet" {
    name                = format("vnet%s", random_string.name.result)
    resource_group_name =  var.resource_gp_name
    location            = var.location
    address_space       = ["10.0.0.0/16"]
    subnet {
        name           = "subnet3"
        address_prefix = "10.0.3.0/24"
        security_group = azurerm_network_security_group.nsg.id
    }
}
