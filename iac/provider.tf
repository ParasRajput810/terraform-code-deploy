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
    subscription_id = "a86fef0d-8b37-4d08-9a3b-a1bb88c6106e"
    resource_provider_registrations = "none"
}