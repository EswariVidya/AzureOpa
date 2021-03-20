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
resource "random_string" "name" {
  length = 8
  special = false
  min_lower   = 8
}
