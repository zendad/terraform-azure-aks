# provider versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.107.0, < 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.0"
    }
  }

  required_version = ">= 1.7.0"
}