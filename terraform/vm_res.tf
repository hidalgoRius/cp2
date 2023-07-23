# BEGIN DEFINE VIRTUAL NETWORK
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vm_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
# END DEFINE VIRTUAL NETWORK


# BEGIN DEFINE resource public IP.
resource "azurerm_public_ip" "pip" {
  name                = "${var.vm_name}-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}
# END DEFINE resource public IP

# BEGIN DEFINE NET IFACES
resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# Diria que este recursos no hace falta.
#resource "azurerm_network_interface" "internal" {
#  name                      = "${var.vm_name}-nic2"
#  resource_group_name       = azurerm_resource_group.rg.name
#  location                  = azurerm_resource_group.rg.location
#
#  ip_configuration {
#    name                          = "internal"
#    subnet_id                     = azurerm_subnet.internal.id
#    private_ip_address_allocation = "Dynamic"
#  }
#}
# END DEFINE NET IFACES


# BEGIN DEFINE VIRTUALMACHINE
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.ssh_user
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 
  plan {
    name      = var.vm_offer #same value for vm_offer
    product   = var.vm_offer #same value for vm_offer
    publisher = var.vm_publisher
  }

  source_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }
}

resource "azurerm_marketplace_agreement" "vmagree" {
  publisher = var.vm_publisher
  offer     = var.vm_offer
  plan      = var.vm_plan
}
