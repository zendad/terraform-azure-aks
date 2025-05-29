output "aks_id" {
  value       = module.aks.aks_id
  description = "The `azurerm_kubernetes_cluster`'s id."
}

output "aks_name" {
  value       = module.aks.aks_name
  description = "The name of the Azure Kubernetes Cluster."
}

output "cluster_fqdn" {
  value       = module.aks.cluster_fqdn
  description = "The FQDN of the Azure Kubernetes Managed Cluster."
}

output "cluster_identity" {
  value       = module.aks.cluster_identity
  description = "The `azurerm_kubernetes_cluster`'s `identity` block."
}

output "host" {
  value       = module.aks.admin_host
  description = "The `host` in the `azurerm_kubernetes_cluster`'s `kube_config` block. The Kubernetes cluster server host."
}

output "http_application_routing_zone_name" {
  value       = module.aks.http_application_routing_zone_name
  description = "The `azurerm_kubernetes_cluster`'s `http_application_routing_zone_name` argument. The Zone Name of the HTTP Application Routing."
}

output "ingress_application_gateway" {
  value       = module.aks.ingress_application_gateway
  description = "The `azurerm_kubernetes_cluster`'s `ingress_application_gateway` block."
}

output "ingress_application_gateway_enabled" {
  value       = module.aks.ingress_application_gateway_enabled
  description = "Has the `azurerm_kubernetes_cluster` turned on `ingress_application_gateway` block?"
}

output "key_vault_secrets_provider" {
  value       = module.aks.key_vault_secrets_provider
  description = "The `azurerm_kubernetes_cluster`'s `key_vault_secrets_provider` block."
}

output "key_vault_secrets_provider_enabled" {
  value       = module.aks.key_vault_secrets_provider_enabled
  description = "Has the `azurerm_kubernetes_cluster` turned on `key_vault_secrets_provider` block?"
}

output "cluster_portal_fqdn" {
  value       = module.aks.cluster_portal_fqdn
  description = "The FQDN for the Azure Portal resources when private link has been enabled, which is only resolvable inside the Virtual Network used by the Kubernetes Cluster."
}

output "cluster_private_fqdn" {
  value       = module.aks.cluster_private_fqdn
  description = "The private FQDN for the Azure Kubernetes Cluster."
}

output "web_app_routing_identity" {
  value       = module.aks.web_app_routing_identity
  description = "The identity used for the web app routing."
}

output "node_resource_group" {
  value       = module.aks.node_resource_group
  description = "The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster."
}

output "oidc_issuer_url" {
  value       = module.aks.oidc_issuer_url
  description = "The URL of the OIDC issuer for the Azure Kubernetes Cluster."
}

output "kube_admin_config_raw" {
  value       = module.aks.kube_admin_config_raw
  description = "The `azurerm_kubernetes_cluster`'s `kube_admin_config_raw` argument. Raw Kubernetes config for the admin account to be used by kubectl and other compatible tools. This is only available when Role Based Access Control with Azure Active Directory is enabled and local accounts enabled."
}

output "kube_config_raw" {
  value       = module.aks.kube_config_raw
  description = "The raw Kubernetes config for the cluster."
}

output "client_certificate" {
  value       = base64decode(module.aks.admin_client_certificate)
  description = "The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block."
}

output "client_key" {
  value       = base64decode(module.aks.admin_client_key)
  description = "The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_config` block."
}

output "cluster_ca_certificate" {
  value       = base64decode(module.aks.admin_cluster_ca_certificate)
  description = "The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block."
}
