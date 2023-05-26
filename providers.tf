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