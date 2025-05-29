# aks resource group
resource "azurerm_resource_group" "aks_rg" {
  name     = "rg-aks-${local.name_prefix}"
  location = var.location
  tags     = var.default_tags
}

# vault resource group
resource "azurerm_resource_group" "vault_rg" {
  name     = "rg-kv-${local.name_prefix}"
  location = var.location
  tags     = var.default_tags
}
