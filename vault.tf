# azure vault 
resource "azurerm_key_vault" "vault" {
  name                            = "${var.vault_name}-${var.environment}-${random_string.suffix.result}-01"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.vault_rg.name
  enabled_for_disk_encryption     = true
  enable_rbac_authorization       = true
  enabled_for_template_deployment = true
  enabled_for_deployment          = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  public_network_access_enabled   = true
  sku_name                        = "standard"

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.default_tags
}

# azure vault key
resource "azurerm_key_vault_key" "aks" {
  name         = "key-aks-${local.name_prefix}"
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
  tags = var.default_tags
}

# wait for azure vault changes to propagate
resource "time_sleep" "wait_for_rbac" {
  depends_on = [azurerm_role_assignment.kv_admin]

  create_duration = "120s"
}

# disk encryption
resource "azurerm_disk_encryption_set" "aks_nodes" {
  name                = "des-aks-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.vault_rg.name
  key_vault_key_id    = azurerm_key_vault_key.aks.versionless_id

  auto_key_rotation_enabled = true

  identity {
    type = "SystemAssigned"
  }
  tags = var.default_tags
}

# azure vault role assignment for admin
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# azure vault role assignmen for disk
resource "azurerm_role_assignment" "node_disk" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.aks_nodes.identity[0].principal_id
}
