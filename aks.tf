# aks module implementation
module "aks" {
  # checkov:skip=CKV_TF_1 reason="Using Terraform Registry with a pinned version instead of git hash"
  source     = "Azure/aks/azurerm"
  version    = "10.2.0"
  depends_on = [azurerm_resource_group.aks_rg]

  # Azure
  prefix              = local.prefix
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = var.location
  tags                = var.default_tags

  # cluster
  cluster_name                 = local.cluster_name
  kubernetes_version           = var.kubernetes_version
  orchestrator_version         = var.kubernetes_version
  image_cleaner_enabled        = var.image_cleaner_enabled
  image_cleaner_interval_hours = var.image_cleaner_interval_hours
  automatic_channel_upgrade    = var.automatic_channel_upgrade
  maintenance_window           = var.maintenance_window
  private_cluster_enabled      = var.private_cluster_enabled

  # Networking
  network_plugin_mode = var.network_plugin_mode
  network_plugin      = var.network_plugin
  network_policy      = var.network_policy
network_contributor_role_assigned_subnet_ids = merge(
  zipmap(
    [for i in range(length(local.public_subnet_names)) : "public-subnet-${i}"],
    local.public_subnet_id_list
  ),
  zipmap(
    [for i in range(length(local.private_subnet_names)) : "private-subnet-${i}"],
    local.private_subnet_id_list
  ),
  zipmap(
    [for i in range(length(local.pod_subnet_names)) : "pod-subnet-${i}"],
    local.pod_subnet_id_list
  )
)



  # Default Node Pool
  enable_auto_scaling          = var.enable_auto_scaling
  agents_availability_zones    = var.agents_availability_zones
  temporary_name_for_rotation  = var.temporary_name_for_rotation
  agents_tags                  = var.default_tags
  agents_pool_name             = var.agents_pool_name
  agents_labels                = var.agents_labels
  agents_type                  = var.agents_type
  agents_count                 = var.agents_count
  agents_min_count             = var.agents_min_count
  agents_max_count             = var.agents_max_count
  agents_size                  = var.agents_size
  os_disk_size_gb              = var.os_disk_size_gb
  only_critical_addons_enabled = var.only_critical_addons_enabled
  vnet_subnet = {
    id = local.default_nodepool_subnet_id
  }
  node_resource_group = local.nodepool_resource_group_name

  # Vault
  key_vault_secrets_provider_enabled = var.key_vault_secrets_provider_enabled
  enable_host_encryption             = var.enable_host_encryption
  disk_encryption_set_id             = azurerm_disk_encryption_set.node.id
  kms_key_vault_key_id               = azurerm_key_vault.vault.id

  # Access
  rbac_aad_tenant_id                = var.rbac_aad_tenant_id
  rbac_aad_azure_rbac_enabled       = var.rbac_aad_azure_rbac_enabled
  workload_identity_enabled         = var.workload_identity_enabled
  oidc_issuer_enabled               = var.oidc_issuer_enabled
  identity_type                     = var.identity_type
  role_based_access_control_enabled = var.role_based_access_control_enabled

  # Logs
  cluster_log_analytics_workspace_name = local.cluster_name
  log_analytics_workspace_enabled      = var.log_analytics_workspace_enabled

  # Cluster autoscaler
  auto_scaler_profile_balance_similar_node_groups   = var.auto_scaler_profile_balance_similar_node_groups
  auto_scaler_profile_expander                      = var.auto_scaler_profile_expander
  auto_scaler_profile_enabled                       = var.auto_scaler_profile_enabled
  auto_scaler_profile_skip_nodes_with_local_storage = var.auto_scaler_profile_skip_nodes_with_local_storage
  auto_scaler_profile_skip_nodes_with_system_pods   = var.auto_scaler_profile_skip_nodes_with_system_pods

  # Nodepools
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