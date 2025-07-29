# aks resource group
resource "azurerm_resource_group" "aks_rg" {
  name     = "rg-aks-${local.name_prefix}"
  location = var.location
  tags     = var.default_tags
}

# tools resource group
resource "azurerm_resource_group" "tools_rg" {
  name     = "rg-tools-${local.name_prefix}"
  location = var.location
  tags     = var.default_tags
}
