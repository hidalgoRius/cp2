# BEGIN LOCAL VARS DEF
locals {
  acr_name = "${var.prefix}${var.acr_name}" # https://github.com/hashicorp/terraform-provider-azurerm/issues/11545 Happens to mee to but it seems to be solved after versio 2.59 and above but it fails for me.
# Error: alpha numeric characters only are allowed in "name": "CP2-acr" 
# So I've removed "-" between vars.

}
# END LOCAL VARS DEF

# BEGIN DEFINE ACR.
resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = true
#  georeplications {
#    location                = "East US"
#    zone_redundancy_enabled = true
#    tags                    = {}
#  }
#  georeplications {
#    location                = "North Europe"
#    zone_redundancy_enabled = true
#    tags                    = {}
#  }
}
# END DEFINE ACR
