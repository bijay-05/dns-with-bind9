resource "azurerm_public_ip" "testip" {
  name                = var.ip_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "testnic" {
  name                = var.nic_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.testip.id
  }

  tags = {
    environment = "dev"
  }
}