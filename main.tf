terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }

  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "RG" {
   name     = "RG-${upper(var.location_abv)}-${upper(var.application)}-${upper(var.enviroment)}"
  location = var.location

  tags = {
    (var.tag_name) = (var.tag_value)
  }

}

resource "azurerm_virtual_network" "Vnet" {
  name                = "Vnet-${upper(var.location_abv)}-${upper(var.application)}-${replace (var.transitVnetAddressSpace, "/","-")}"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  address_space       = [var.transitVnetAddressSpace]
  dns_servers         = [var.dns1, var.dns2]

  tags = {
    (var.tag_name) = (var.tag_value)

  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = [cidrsubnet(var.transitVnetAddressSpace, 3, 2)]
}



resource "azurerm_network_interface" "NIC" {
  name                = "VM-${upper(var.location_abv)}-${upper(var.application)}-${upper(var.enviroment)}-nic"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    
    private_ip_address_allocation = "Dynamic"
    #private_ip_address_allocation = "static"
    #private_ip_address            = cidrhost(cidrsubnet(var.transitVnetAddressSpace, 3, 2), 4)
    public_ip_address_id          = azurerm_public_ip.PIPMNGT.id
  }
}

resource "azurerm_virtual_machine" "VM" {
  name                  = "VM-${upper(var.location_abv)}-${upper(var.application)}-${upper(var.enviroment)}"
  location              = azurerm_resource_group.RG.location
  resource_group_name   = azurerm_resource_group.RG.name
  network_interface_ids = [azurerm_network_interface.NIC.id]
  vm_size               = "Standard_DS1_v2"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "VM-${upper(var.location_abv)}-${upper(var.application)}-${upper(var.enviroment)}-OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}