
resource "azurerm_public_ip" "PIPMNGT" {
  name                = "PIP-VM-${upper(var.location_abv)}-${upper(var.application)}-${upper(var.enviroment)}"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  allocation_method = "Dynamic"
}

resource "azurerm_network_security_group" "Internal" {
  name                = "NSG-Subnet-Internal"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  tags = {
    (var.tag_name) = (var.tag_value)

  }

}

resource "azurerm_network_security_rule" "ManagementRule" {
  resource_group_name         = azurerm_resource_group.RG.name
  network_security_group_name = azurerm_network_security_group.Internal.name
  name                        = "AllowManagement"
  description                 = "value"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["443", "22"]
  source_address_prefixes     = var.WhiteListManagement
  destination_address_prefix  = cidrhost(cidrsubnet(var.transitVnetAddressSpace, 3, 2), 4)

}