# BEGIN LOCAL VARS DEF
locals {
  rg_name = "${var.env}-${var.prefix}-${var.resource_group_name}"
}
# END LOCAL VARS DEF

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}
