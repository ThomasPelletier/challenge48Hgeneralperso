terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.42.0" 
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.28.1"
    }
    ovh = {
      source = "ovh/ovh"
      version = "0.26.0"
    }
  }
  
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstate18524"
      container_name       = "tfstate"
      key                  = "decrentralized_deals.tfstate"
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

provider "ovh" {

}