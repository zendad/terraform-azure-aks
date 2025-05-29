# client config
data "azurerm_client_config" "current" {}

# Get AD groups
data "azuread_group" "k8s_groups" {
  for_each     = toset(local.cluster_roles)
  display_name = each.key
}
