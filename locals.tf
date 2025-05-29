# random string
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# locals variables
locals {
  azure_regions_shortname = {
    "australiaeast"      = "aue"
    "australiasoutheast" = "aus"
    "brazilsouth"        = "brs"
    "canadacentral"      = "cac"
    "canadaeast"         = "cae"
    "centralindia"       = "cin"
    "centralus"          = "cus"
    "eastasia"           = "eas"
    "eastus"             = "eus"
    "eastus2"            = "eus2"
    "francecentral"      = "frc"
    "germanywestcentral" = "gwc"
    "japaneast"          = "jpe"
    "japanwest"          = "jpw"
    "koreacentral"       = "krc"
    "northcentralus"     = "ncus"
    "northeurope"        = "neu"
    "norwayeast"         = "nwe"
    "southafricanorth"   = "san"
    "southcentralus"     = "scus"
    "southindia"         = "sin"
    "southeastasia"      = "sea"
    "swedencentral"      = "sec"
    "switzerlandnorth"   = "chn" # Yes, "chn" is used even though it's odd
    "uaenorth"           = "uan"
    "uksouth"            = "uks"
    "ukwest"             = "ukw"
    "westeurope"         = "weu"
    "westus"             = "wus"
    "westus2"            = "wus2"
    "westus3"            = "wus3"
  }

  name_prefix  = "${var.environment}-${local.azure_regions_shortname[var.location]}"
  vnet_name    = "vnet-${local.name_prefix}"
  cluster_name = "aks-cluster-${local.name_prefix}"

  node_subnet_names    = [for i in range(1, 4) : "snet-node-${local.name_prefix}-${i}"]
  pod_subnet_names     = [for i in range(1, 4) : "snet-pod-${local.name_prefix}-${i}"]
  public_subnet_names  = [for i in range(1, 4) : "snet-public-${local.name_prefix}-${i}"]
  private_subnet_names = [for i in range(1, 4) : "snet-private-${local.name_prefix}-${i}"]

  # Workload subnets (/22)
  node_subnet_cidrs = [
    cidrsubnet(var.vnet_cidr, 6, 0),
    cidrsubnet(var.vnet_cidr, 6, 1),
    cidrsubnet(var.vnet_cidr, 6, 2)
  ]

  # Pod subnets (/21)
  pod_subnet_cidrs = [
    cidrsubnet(var.vnet_cidr, 5, 10),
    cidrsubnet(var.vnet_cidr, 5, 11),
    cidrsubnet(var.vnet_cidr, 5, 12)
  ]

  # Public subnets (/24)
  public_subnet_cidrs = [
    cidrsubnet(var.vnet_cidr, 8, 20),
    cidrsubnet(var.vnet_cidr, 8, 21),
    cidrsubnet(var.vnet_cidr, 8, 22)
  ]

  # Private subnets (/24)
  private_subnet_cidrs = [
    cidrsubnet(var.vnet_cidr, 8, 30),
    cidrsubnet(var.vnet_cidr, 8, 31),
    cidrsubnet(var.vnet_cidr, 8, 32)
  ]

  # Count each type
  node_subnet_count    = length(local.node_subnet_names)
  pod_subnet_count     = length(local.pod_subnet_names)
  public_subnet_count  = length(local.public_subnet_names)
  private_subnet_count = length(local.private_subnet_names)

  # Split the flat list of subnet IDs from the module into slices
  node_subnet_id_list = slice(module.network.vnet_subnets, 0, local.node_subnet_count)

  pod_subnet_id_list = slice(
    module.network.vnet_subnets,
    local.node_subnet_count,
    local.node_subnet_count + local.pod_subnet_count
  )

  public_subnet_id_list = slice(
    module.network.vnet_subnets,
    local.node_subnet_count + local.pod_subnet_count,
    local.node_subnet_count + local.pod_subnet_count + local.public_subnet_count
  )

  private_subnet_id_list = slice(
    module.network.vnet_subnets,
    local.node_subnet_count + local.pod_subnet_count + local.public_subnet_count,
    length(module.network.vnet_subnets)
  )

  # Automatically allocate subnets to node pools in a round-robin manner
  node_pools_with_subnets = {
    for idx, key in keys(var.node_pools) :
    key => merge(var.node_pools[key], {
      subnet_id     = local.node_subnet_id_list[idx % length(local.node_subnet_id_list)],
      pod_subnet_id = local.pod_subnet_id_list[idx % length(local.pod_subnet_id_list)]
    })
  }
  cluster_roles = [
    "aks-cluster-admin",
    "aks-cluster-cluster-operator",
    "aks-cluster-cluster-viewer"
  ]
}