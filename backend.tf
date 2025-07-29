/*
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-test-gwc"
    storage_account_name = "backendtfstatetestgwc01"
    container_name       = "backend-tfstate-test-gwc-01"
    key                  = "aks/test/gmc/tf.tfstate"
  }
}
*/