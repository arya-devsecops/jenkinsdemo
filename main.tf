terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "6a721293-3126-4dd0-b9b5-9b4e51d98f04"
}

resource "azurerm_resource_group" "main" {
  name     = "DsoRG"
  location = "East US"
}
