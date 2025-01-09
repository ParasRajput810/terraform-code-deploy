terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }
}

provider "azurerm" {
    features {}
    subscription_id = "7c68b5d5-e5af-4e27-835b-2b9a4cd010d9"
    resource_provider_registrations = "none"
}