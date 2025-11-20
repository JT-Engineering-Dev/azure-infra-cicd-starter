terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {
    resource_group_name  = "jteng-tfstate-rg"
    storage_account_name = "jtengtfstate01"
    container_name       = "tfstate"
    key                  = "azure-infra-cicd-starter.tfstate"
    use_azuread_auth     = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.114"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
