terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.51.0"
    }
  }
    backend "azurerm" {
    resource_group_name = "tfstate-rg"
    storage_account_name = "tfstatexltgldt"
    container_name = "tfstate"
    key = "teraform.tfstate"
  }
}

provider "azurerm" {
  features {

  }
  skip_provider_registration = true
}

resource "azurerm_resource_group" "lb_rg" {
  name = "lb-rg"
  location = "Central India"
}