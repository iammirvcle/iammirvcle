terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "rg_name" {
  type    = string
  default = "rg-tf-lab"
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

# Optional: storage account to show dependencies
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "sa" {
  name                     = "tfstor${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
