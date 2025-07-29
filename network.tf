# vnet and subnets for aks cluster
module "network" {
  # checkov:skip=CKV_TF_1 reason="Using Terraform Registry with a pinned version instead of git hash"
  depends_on          = [azurerm_resource_group.aks_rg]
  source              = "Azure/network/azurerm"
  version             = "5.3.0"
  use_for_each        = true
  resource_group_name = azurerm_resource_group.aks_rg.name
  vnet_name           = local.vnet_name
  address_spaces      = [var.vnet_cidr]
  subnet_prefixes     = concat(local.public_subnet_cidrs, local.private_subnet_cidrs, local.pod_subnet_cidrs)
  subnet_names        = concat(local.public_subnet_names, local.private_subnet_names, local.pod_subnet_names)
  tags                = var.default_tags
}

resource "azurerm_public_ip" "nat_ip" {
  name                = "nat-ip-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  zones               = var.availability_zones
}

resource "azurerm_nat_gateway" "nat" {
  name                    = "nat-gateway-${local.name_prefix}"
  location                = var.location
  resource_group_name     = azurerm_resource_group.aks_rg.name
  sku_name                = var.nat_gateway_sku_name
  zones                   = var.availability_zones
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
}

resource "azurerm_subnet_nat_gateway_association" "nat_assoc" {
  for_each = {
    for idx, subnet_id in concat(
      local.public_subnet_id_list,
      local.private_subnet_id_list,
      local.pod_subnet_id_list
    ) : idx => subnet_id
  }

  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.nat.id
}


resource "azurerm_nat_gateway_public_ip_association" "nat" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}