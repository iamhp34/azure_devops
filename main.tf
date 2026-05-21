terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "default-rg"
  location = "East US"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "default-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "default-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Call the Child Module to build the VM
module "my_basic_vm" {
  source    = "./modules/basic_vm"
  rg_name   = azurerm_resource_group.rg.name
  location  = azurerm_resource_group.rg.location
  subnet_id = azurerm_subnet.subnet.id
}
