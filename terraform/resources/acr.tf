# BEGIN DEFINE ACR.
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = false
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
