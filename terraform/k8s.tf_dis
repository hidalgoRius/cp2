resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "k8s"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}-k8s-dns"

  default_node_pool {
    name       = "agentpool"
    node_count = var.env=="dev" ? 1:var.k8s_node_count #En mi entorno dev solo 1 nodo, en prod, los especificados en la variable.
    vm_size    = var.env=="dev" ? "Standard_D2_v2":"Standard_D2_v2" # A ejemplos del CP2, especificamos misma máquina.
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.env # Especificamos el valor del entorno definido en la variable.
  }
}

resource "azurerm_role_assignment" "acr2k8s" {
  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
