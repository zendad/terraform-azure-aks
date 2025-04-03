locals {
  name_prefix      = "${var.environment}-${var.location}"
  resource_group   = "${local.name_prefix}-rg"
  vnet_name        = "${local.name_prefix}-vnet"
  cluster_name     = "${local.name_prefix}-aks"
  subnet_names     = [for i in range(1, 4) : "${local.name_prefix}-${i}-subnet"]
  pod_subnet_names = [for i in range(1, 4) : "${local.name_prefix}-pod-${i}-subnet"]

  # Calculate subnet CIDRs dynamically (each subnet gets a /22 block)
  subnet_cidrs = [
    cidrsubnet(var.vnet_cidr, 6, 0),
    cidrsubnet(var.vnet_cidr, 6, 1),
    cidrsubnet(var.vnet_cidr, 6, 2)
  ]

  # Create separate subnets for pods to support 2000 pods each (using /21 subnet masks)
  pod_subnet_cidrs = [
    cidrsubnet(var.vnet_cidr, 5, 0),
    cidrsubnet(var.vnet_cidr, 5, 1),
    cidrsubnet(var.vnet_cidr, 5, 2)
  ]

  # Automatically allocate subnets to node pools in a round-robin manner
  node_pools_with_subnets = {
    for idx, key in keys(var.node_pools) :
    key => merge(var.node_pools[key], {
      subnet_id     = module.network.aks_subnet_ids[idx % length(module.network.aks_subnet_ids)],
      pod_subnet_id = module.network.aks_pod_subnet_ids[idx % length(module.network.aks_pod_subnet_ids)]
    })
  }

}