# AKS Cluster Creation
This repository contains the implementation of the (Azure/aks/azurerm)[Azure/aks/azurerm] Terraform module to provision an Azure Kubernetes Service (AKS) cluster with configurable node pools, autoscaling, and optional features like OIDC and KMS encryption. This also implemements the necessary resource groups,virtual network (VNet) and subnets for the AKS cluster.

# VNet and Subnets for AKS Cluster
The following provisions a Virtual Network and multiple subnets required for the AKS cluster, including node, pod, public, and private subnets.
```hcl
module "network" {
  depends_on          = [azurerm_resource_group.aks_rg]
  source              = "Azure/network/azurerm"
  version             = "5.3.0"
  use_for_each        = true
  resource_group_name = azurerm_resource_group.aks_rg.name
  vnet_name           = local.vnet_name
  address_spaces      = [var.vnet_cidr]
  subnet_prefixes     = concat(local.node_subnet_cidrs, local.pod_subnet_cidrs, local.public_subnet_cidrs, local.private_subnet_cidrs)
  subnet_names        = concat(local.node_subnet_names, local.pod_subnet_names, local.public_subnet_names, local.private_subnet_names)
  tags                = var.default_tags
}
```

# AKS Deployment
This module provisions the AKS cluster using the official Azure AKS Terraform module with autoscaling, node pools, KMS encryption, and more.
```hcl
module "aks" {
  source                                            = "Azure/aks/azurerm"
  version                                           = "10.0.1"
  prefix                                            = "aks-${local.name_prefix}"
  depends_on                                        = [azurerm_resource_group.aks_rg]
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
  image_cleaner_enabled                             = true
  image_cleaner_interval_hours                      = 72
  key_vault_secrets_provider_enabled                = true
  kms_key_vault_key_id                              = azurerm_key_vault_key.aks.id

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
````


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.107.0, < 4.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.35.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.0.2 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.35.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.13.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | Azure/aks/azurerm | 10.0.1 |
| <a name="module_network"></a> [network](#module\_network) | Azure/network/azurerm | 5.3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_disk_encryption_set.aks_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_key_vault.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_key.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_resource_group.aks_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.vault_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.kv_admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.node_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [kubernetes_cluster_role_binding.cluster_bindings](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_manifest.cluster_roles](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/3.3.2/docs/resources/string) | resource |
| [time_sleep.wait_for_rbac](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_group.k8s_groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_server_authorized_ip_ranges"></a> [api\_server\_authorized\_ip\_ranges](#input\_api\_server\_authorized\_ip\_ranges) | Set of authorized IP ranges for the API server | `set(string)` | `[]` | no |
| <a name="input_auto_scaler_profile_balance_similar_node_groups"></a> [auto\_scaler\_profile\_balance\_similar\_node\_groups](#input\_auto\_scaler\_profile\_balance\_similar\_node\_groups) | Detect similar node groups and balance the number of nodes between them | `bool` | `false` | no |
| <a name="input_auto_scaler_profile_expander"></a> [auto\_scaler\_profile\_expander](#input\_auto\_scaler\_profile\_expander) | Auto-scaler profile expander setting. Possible values are least-waste, priority, most-pods, and random. Defaults to random. | `string` | `"random"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to use | `list(string)` | `[]` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags for all resources | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | AKS kubernetes version | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure Region | `string` | `""` | no |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | Network plugin for AKS | `string` | `""` | no |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | network policy to be used with Azure CNI | `string` | `""` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Map of node pools with configuration | <pre>map(object({<br/>    name                = string<br/>    vm_size             = string<br/>    enable_auto_scaling = bool<br/>    min_count           = number<br/>    max_count           = number<br/>    node_taints         = list(string)<br/>    os_disk_size_gb     = number<br/>    max_pods            = number<br/>    mode                = string<br/>    priority            = string<br/>    os_type             = string<br/>    node_labels         = map(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Subscription ID | `string` | `""` | no |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | name for key vault | `string` | `"kv-cluster"` | no |
| <a name="input_vnet_cidr"></a> [vnet\_cidr](#input\_vnet\_cidr) | CIDR block for the Virtual Network | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_id"></a> [aks\_id](#output\_aks\_id) | The `azurerm_kubernetes_cluster`'s id. |
| <a name="output_aks_name"></a> [aks\_name](#output\_aks\_name) | The name of the Azure Kubernetes Cluster. |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_config` block. |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. |
| <a name="output_cluster_fqdn"></a> [cluster\_fqdn](#output\_cluster\_fqdn) | The FQDN of the Azure Kubernetes Managed Cluster. |
| <a name="output_cluster_identity"></a> [cluster\_identity](#output\_cluster\_identity) | The `azurerm_kubernetes_cluster`'s `identity` block. |
| <a name="output_cluster_portal_fqdn"></a> [cluster\_portal\_fqdn](#output\_cluster\_portal\_fqdn) | The FQDN for the Azure Portal resources when private link has been enabled, which is only resolvable inside the Virtual Network used by the Kubernetes Cluster. |
| <a name="output_cluster_private_fqdn"></a> [cluster\_private\_fqdn](#output\_cluster\_private\_fqdn) | The private FQDN for the Azure Kubernetes Cluster. |
| <a name="output_cluster_vnet_id"></a> [cluster\_vnet\_id](#output\_cluster\_vnet\_id) | AKS cluster vnet |
| <a name="output_host"></a> [host](#output\_host) | The `host` in the `azurerm_kubernetes_cluster`'s `kube_config` block. The Kubernetes cluster server host. |
| <a name="output_http_application_routing_zone_name"></a> [http\_application\_routing\_zone\_name](#output\_http\_application\_routing\_zone\_name) | The `azurerm_kubernetes_cluster`'s `http_application_routing_zone_name` argument. The Zone Name of the HTTP Application Routing. |
| <a name="output_ingress_application_gateway"></a> [ingress\_application\_gateway](#output\_ingress\_application\_gateway) | The `azurerm_kubernetes_cluster`'s `ingress_application_gateway` block. |
| <a name="output_ingress_application_gateway_enabled"></a> [ingress\_application\_gateway\_enabled](#output\_ingress\_application\_gateway\_enabled) | Has the `azurerm_kubernetes_cluster` turned on `ingress_application_gateway` block? |
| <a name="output_key_vault_secrets_provider"></a> [key\_vault\_secrets\_provider](#output\_key\_vault\_secrets\_provider) | The `azurerm_kubernetes_cluster`'s `key_vault_secrets_provider` block. |
| <a name="output_key_vault_secrets_provider_enabled"></a> [key\_vault\_secrets\_provider\_enabled](#output\_key\_vault\_secrets\_provider\_enabled) | Has the `azurerm_kubernetes_cluster` turned on `key_vault_secrets_provider` block? |
| <a name="output_kube_admin_config_raw"></a> [kube\_admin\_config\_raw](#output\_kube\_admin\_config\_raw) | The `azurerm_kubernetes_cluster`'s `kube_admin_config_raw` argument. Raw Kubernetes config for the admin account to be used by kubectl and other compatible tools. This is only available when Role Based Access Control with Azure Active Directory is enabled and local accounts enabled. |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | The raw Kubernetes config for the cluster. |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group) | The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster. |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | The URL of the OIDC issuer for the Azure Kubernetes Cluster. |
| <a name="output_web_app_routing_identity"></a> [web\_app\_routing\_identity](#output\_web\_app\_routing\_identity) | The identity used for the web app routing. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
