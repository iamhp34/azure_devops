# Create a Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "default-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "default"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create the Basic Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "default-vm"
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  admin_password                  = "DefaultPassword123!"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
