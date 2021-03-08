provider "azurerm" {
    #version = "~>2.13.0"
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
    client_id = var.client_id
    client_secret = var.client_secret
    features{}
}

terraform {
    backend "azurerm" {}
}

data "azurerm_client_config" "current" {}

#data "azurerm_resources" "resource_group" {
#  type = "Microsoft.Resources/subscriptions/resourceGroups/*"
#} 

#resource "azurerm_network_security_group" "nsg" {
#    name = "myTFNSG"
#    location = var.location
#    resource_group_name = var.resource_gp_name
 #   security_rule {
 #       name = "SSH"
 #       priority = 1001
 #       direction = "Inbound"
 #       access = "Allow"
 #       protocol = "Tcp"
 #       source_port_range = "*"
 #       destination_port_range = "22"
 #       source_address_prefix = "*"
 #       destination_address_prefix = "*"

  #  }
#}

resource "azurerm_storage_account" "teststorageaccount1" {
  name                      = "devsecopsstorageaccount"
  resource_group_name       = var.resource_gp_name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = false

  network_rules {
    default_action          = "Deny"
  }
}

#resource "azurerm_storage_container" "testcontainer" {
#  name                    = "decsecopsstoragecontainer"
#  storage_account_name    = azurerm_storage_account.teststorageaccount1.name
#  container_access_type   = "private"
#}
