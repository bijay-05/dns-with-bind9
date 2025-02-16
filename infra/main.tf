resource "azurerm_resource_group" "testrg" {
    name = "devtestrg"
    location = "centralindia"
    tags = {
        environment = "dev"
    }
}

resource "azurerm_virtual_network" "testvnet" {
    name = "devtestvnet"
    resource_group_name = azurerm_resource_group.testrg.name
    location = azurerm_resource_group.testrg.location
    address_space = ["10.123.0.0/16"]

    tags = {
        environment = "dev"
    }
}

resource "azurerm_subnet" "testsubnet" {
    name = "devtestsubnet"
    resource_group_name = azurerm_resource_group.testrg.name
    virtual_network_name = azurerm_virtual_network.testvnet.name
    address_prefixes = ["10.123.1.0/24"]
}

module "network_security" {
    source = "github.com/bijay-05/terraform-module-collection/azure/vm_network_security"
    rg_name = azurerm_resource_group.testrg.name
    rg_location = azurerm_resource_group.testrg.location
    subnet_id = azurerm_subnet.testsubnet.id
    nsg_name = "devtestnsg"
    nsr_name = "devtestnsr"
}

module "network_interface_a" {
    source = "github.com/bijay-05/terraform-module-collection/azure/vm_network_interface"
    rg_name = azurerm_resource_group.testrg.name
    rg_location = azurerm_resource_group.testrg.location
    ip_name = "devtestipa"
    nic_name = "devtestnica"
    subnet_id = azurerm_subnet.testsubnet.id
}

module "network_interface_b" {
    source = "github.com/bijay-05/terraform-module-collection/azure/plain_vm_network_interface"
    rg_name = azurerm_resource_group.testrg.name
    rg_location = azurerm_resource_group.testrg.location
    nic_name = "devtestnicb"
    subnet_id = azurerm_subnet.testsubnet.id
}

module "linux_vm_a" {
    source = "github.com/bijay-05/terraform-module-collection/azure/linuxvm"
    rg_name = azurerm_resource_group.testrg.name
    rg_location = azurerm_resource_group.testrg.location
    vm_name = "devtestvma"
    vm_size = "Standard_B2s"
    admin_username = "devusera"
    nic_id = module.network_interface_a.nic_id
}

module "linux_vm_b" {
    source = "github.com/bijay-05/terraform-module-collection/azure/linuxvm"
    rg_name = azurerm_resource_group.testrg.name
    rg_location = azurerm_resource_group.testrg.location
    vm_name = "devtestvmb"
    vm_size = "Standard_B1s"
    admin_username = "devuserb"
    nic_id = module.network_interface_b.nic_id
}