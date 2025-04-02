module "aks" {
  source  = "Azure/aks/azurerm"
  version = "9.4.1"

  resource_group_name                 = azurerm_resource_group.aks_rg.name
  cluster_name                        = local.cluster_name
  location                            = var.location
  private_cluster_enabled             = true
  rbac_aad                            = true
  rbac_aad_managed                    = true
  role_based_access_control_enabled   = true
  api_server_authorized_ip_ranges     = toset(concat([var.vnet_cidr], tolist(var.api_server_authorized_ip_ranges)))
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  tags                                = var.default_tags
  kubernetes_version                  = var.kubernetes_version
  orchestrator_version                = var.kubernetes_version
  network_plugin                      = var.network_plugin
  network_policy                      = var.network_policy
  oidc_issuer_enabled                 = true

  auto_scaler_profile_balance_similar_node_groups   = var.auto_scaler_profile_balance_similar_node_groups
  auto_scaler_profile_enabled                       = true
  auto_scaler_profile_expander                      = var.auto_scaler_profile_expander
  auto_scaler_profile_skip_nodes_with_local_storage = false
  auto_scaler_profile_skip_nodes_with_system_pods   = false

  node_pools = {
    for key, pool in local.node_pools_with_subnets : key => {
      name                = "${local.name_prefix}-${pool.name}"
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
      node_taints         = pool.taints
      node_labels         = pool.labels
      tags                = var.default_tags
    }
  }
}