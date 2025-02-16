resource "azurerm_network_security_group" "testnsg" {
  name                = var.nsg_name
  resource_group_name = var.rg_name
  location            = var.rg_location

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "testnsr" {
  name                        = var.nsr_name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.testnsg.name
}

resource "azurerm_subnet_network_security_group_association" "testsnsga" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.testnsg.id
}

