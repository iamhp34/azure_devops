# modules/virtual_machine/main.tf

# 1. EXPLICIT INPUT VARIABLES (This fixes the "Unsupported argument" error)
variable "resource_group_name" { type = string }
variable "location"            { type = string }

# 2. VIRTUAL NETWORK
resource "azurerm_virtual_network" "vnet" {
  name                = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# 3. SUBNET
resource "azurerm_subnet" "subnet" {
  name                 = "demo-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 4. NETWORK INTERFACE
resource "azurerm_network_interface" "nic" {
  name                = "demo-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# 5. VIRTUAL MACHINE (Free Tier Eligible in India)
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "demo-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2ats_v2" # Free tier eligible compute size
  admin_username      = "azureuser"
  
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_password                  = "SecurePassword123!"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}