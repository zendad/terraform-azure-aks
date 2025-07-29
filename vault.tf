# azure vault 
resource "azurerm_key_vault" "vault" {
  name                            = "${var.vault_name}-${var.environment}-${random_string.suffix.result}-01"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.tools_rg.name
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enable_rbac_authorization       = var.enable_rbac_authorization
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enabled_for_deployment          = var.enabled_for_deployment
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  sku_name                        = var.key_vault_sku_name

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = var.key_vault_ip_rules
  }

  tags = var.default_tags
}

# azure vault key
resource "azurerm_key_vault_key" "node" {
  name            = "key-aks-${local.name_prefix}"
  key_vault_id    = azurerm_key_vault.vault.id
  key_type        = var.key_vault_key_type
  key_size        = var.key_vault_key_size
  key_opts        = var.key_vault_key_opts
  expiration_date = local.key_expiration_date
  lifecycle {
    ignore_changes = [expiration_date]
  }
  tags = var.default_tags
}

# wait for azure vault changes to propagate
resource "time_sleep" "wait_for_rbac" {
  depends_on = [azurerm_role_assignment.admin]

  create_duration = var.key_vault_key_create_duration
}

# disk encryption
resource "azurerm_disk_encryption_set" "node" {
  name                = "des-aks-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.tools_rg.name
  key_vault_key_id    = azurerm_key_vault_key.node.versionless_id

  auto_key_rotation_enabled = var.key_vault_key_auto_rotation_enabled

  identity {
    type = "SystemAssigned"
  }
  tags = var.default_tags
}

# azure vault role assignment for admin
resource "azurerm_role_assignment" "admin" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = var.key_vault_role_definition_name
  principal_id         = data.azurerm_client_config.current.object_id
}

# azure vault role assignmen for disk
resource "azurerm_role_assignment" "node" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = var.key_vault_node_role_definition_name
  principal_id         = azurerm_disk_encryption_set.node.identity[0].principal_id
}