# aks module implementation
module "aks" {

  source                                            = "Azure/aks/azurerm"
  version                                           = "10.0.1"
  depends_on                                        = [azurerm_resource_group.aks_rg]
  prefix                                            = "aks-${local.name_prefix}"
  resource_group_name                               = azurerm_resource_group.aks_rg.name
  cluster_name                                      = local.cluster_name
  location                                          = var.location
  role_based_access_control_enabled                 = true
  tags                                              = var.default_tags
  kubernetes_version                                = var.kubernetes_version
  orchestrator_version                              = var.kubernetes_version
  network_plugin                                    = var.network_plugin
  network_policy                                    = var.network_policy
  oidc_issuer_enabled                               = true
  enable_auto_scaling                               = true
  agents_count                                      = null
  agents_min_count                                  = 1
  agents_max_count                                  = 5
  agents_size                                       = "Standard_D2s_v3"
  temporary_name_for_rotation                       = "tempnodepool"
  agents_tags                                       = var.default_tags
  auto_scaler_profile_balance_similar_node_groups   = var.auto_scaler_profile_balance_similar_node_groups
  auto_scaler_profile_enabled                       = true
  auto_scaler_profile_expander                      = var.auto_scaler_profile_expander
  auto_scaler_profile_skip_nodes_with_local_storage = false
  auto_scaler_profile_skip_nodes_with_system_pods   = false
  log_analytics_workspace_enabled                   = false
  cluster_log_analytics_workspace_name              = local.cluster_name
  #disk_encryption_set_id                            = azurerm_disk_encryption_set.aks_nodes.id
  image_cleaner_enabled              = true
  image_cleaner_interval_hours       = 72
  key_vault_secrets_provider_enabled = true
  kms_key_vault_key_id               = azurerm_key_vault_key.aks.id

  node_pools = {
    for key, pool in local.node_pools_with_subnets : key => {
      name                = pool.name
      vm_size             = pool.vm_size
      enable_auto_scaling = pool.enable_auto_scaling
      min_count           = pool.min_count
      max_count           = pool.max_count
      availability_zones  = var.availability_zones
      vnet_subnet_id      = pool.subnet_id
      max_pods            = pool.max_pods
      mode                = pool.mode
      zones               = var.availability_zones
      pod_subnet_id       = pool.pod_subnet_id
      priority            = pool.priority
      os_type             = pool.os_type
      os_disk_size_gb     = pool.os_disk_size_gb
      node_taints         = pool.node_taints
      node_labels         = pool.node_labels
      tags                = var.default_tags
    }
  }
}