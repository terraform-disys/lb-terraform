terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.51.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  skip_provider_registration = true
}


resource "azurerm_resource_group" "lb_rg" {
  name     = "lb-rg"
  location = "Central India"
}

resource "azurerm_virtual_network" "lb_vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "lb_subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.lb_rg.name
  virtual_network_name = azurerm_virtual_network.lb_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}