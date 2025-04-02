resource "azurerm_resource_group" "aks_rg" {
  name     = local.resource_group
  location = var.location
  tags     = var.default_tags
}