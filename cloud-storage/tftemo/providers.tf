terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.25.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }

  }
}

provider "azurerm" {
  features {}

  subscription_id = "0f742d4d-18f7-43ad-b56c-6c77e9170a78"
}
