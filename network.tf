module "network" {
  depends_on          = [azurerm_resource_group.aks_rg]
  source              = "Azure/network/azurerm"
  version             = "5.2.0"
  use_for_each        = true
  resource_group_name = azurerm_resource_group.aks_rg.name
  vnet_name           = local.vnet_name
  address_spaces      = [var.vnet_cidr]
  subnet_prefixes     = concat(local.subnet_cidrs, local.pod_subnet_cidrs)
  subnet_names        = concat(local.subnet_names, local.pod_subnet_names)
  tags                = var.default_tags
}

