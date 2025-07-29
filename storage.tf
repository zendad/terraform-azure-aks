# tf state storage
resource "azurerm_storage_account" "backend" {
  name                     = replace("backend-tfstate-${local.name_prefix}-01", "-", "")
  resource_group_name      = azurerm_resource_group.tools_rg.name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = var.default_tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "backend-tfstate-${local.name_prefix}-01"
  storage_account_name  = azurerm_storage_account.backend.name
  container_access_type = var.container_access_type
}
