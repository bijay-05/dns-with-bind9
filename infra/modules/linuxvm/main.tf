resource "azurerm_linux_virtual_machine" "testvm" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    var.nic_id,
  ]

  # custom_data = filebase64("./customdata.tftpl")

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("./demon.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }
}