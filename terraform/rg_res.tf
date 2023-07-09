# BEGIN LOCAL VARS DEF
locals {
  rg_name = "${var.prefix}-${var.resource_group_name}-${var.env}"
}
# END LOCAL VARS DEF

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}
