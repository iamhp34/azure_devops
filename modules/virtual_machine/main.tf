# Inside modules/virtual_machine/main.tf

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "demo-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2ats_v2" # <-- Updated to Free Tier AMD size
  admin_username      = "azureuser"
  
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_password                  = "SecurePassword123!"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS" # Standard HDD/SSD is covered under free allocation
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}