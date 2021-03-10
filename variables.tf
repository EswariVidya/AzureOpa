variable "subscription_id"{}
variable "tenant_id"{}
variable "client_id"{}
variable "client_secret"{}
variable "resource_gp_name"{
  default = " "
}
variable "location" {
  type = string
  default = "westeurope"
}

resource "random_string" "userPassword" {
  length      = 8
  special     = true
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  min_special = 1
  override_special = "$%_-#@"
}
