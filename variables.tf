variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = ""
}

variable "kubernetes_version" {
  description = "AKS kubernetes version"
  type        = string
  default     = ""
}

variable "vnet_cidr" {
  description = "CIDR block for the Virtual Network"
  type        = string
  default     = ""
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = []
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
}

variable "network_plugin" {
  description = "Network plugin for AKS"
  type        = string
  default     = ""
}

variable "network_policy" {
  description = "network policy to be used with Azure CNI"
  type        = string
  default     = ""
}

variable "api_server_authorized_ip_ranges" {
  description = "Set of authorized IP ranges for the API server"
  type        = set(string)
  default     = null
}

variable "vault_name" {
  description = "name for key vault"
  type        = string
  default     = "kv-cluster"
}


variable "account_tier" {
  description = "The performance tier of the storage account (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type of the storage account (e.g., LRS, GRS, ZRS)"
  type        = string
  default     = "LRS"
}

variable "container_access_type" {
  description = "The access level of the storage container (private, blob, or container)"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "blob", "container"], var.container_access_type)
    error_message = "container_access_type must be one of: private, blob, or container"
  }
}

variable "role_based_access_control_enabled" {
  type        = bool
  default     = true
  description = "Enable Role-Based Access Control (RBAC) for the AKS cluster to manage permissions using Azure AD or Kubernetes native roles."
}

variable "oidc_issuer_enabled" {
  type        = bool
  default     = true
  description = "Enable the OpenID Connect (OIDC) issuer URL, which is required for Kubernetes workload identity and federated identity with external systems."
}

variable "enable_auto_scaling" {
  type        = bool
  default     = true
  description = "Enable cluster autoscaler for the AKS node pool to automatically adjust the number of nodes based on workload demand."
}

variable "temporary_name_for_rotation" {
  type        = string
  default     = "tempnodepool"
  description = "Temporary name used for a node pool during node rotation or upgrade operations in the AKS cluster. This allows seamless replacement before removing the old node pool."
}

variable "agents_count" {
  type        = number
  default     = null
  description = "Specifies the number of agent nodes to provision. If null and autoscaling is enabled, min and max counts are used."
}

variable "agents_min_count" {
  type        = number
  default     = 1
  description = "The minimum number of agent nodes for the node pool when autoscaling is enabled."
}

variable "agents_max_count" {
  type        = number
  default     = 3
  description = "The maximum number of agent nodes for the node pool when autoscaling is enabled."
}

variable "agents_size" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "The VM size to use for the agent node pool in the AKS cluster."
}

variable "log_analytics_workspace_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether a Log Analytics workspace should be linked to the AKS cluster for monitoring."
}

variable "image_cleaner_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable the image cleaner in the AKS cluster to automatically remove unused container images."
}

variable "image_cleaner_interval_hours" {
  type        = number
  default     = 72
  description = "The interval in hours at which the image cleaner should run to clean up unused container images."
}

variable "agents_pool_name" {
  type        = string
  default     = "platformpool"
  description = "The name assigned to the default AKS agent node pool. This name must be unique within the AKS cluster and 3–12 characters long."
}

variable "agents_type" {
  type        = string
  default     = "VirtualMachineScaleSets"
  description = "Specifies the type of agent pool to use for the AKS cluster. Supported values are 'VirtualMachineScaleSets' (VMSS) and 'AvailabilitySet' (deprecated for new clusters)."
}

variable "agents_labels" {
  type        = map(string)
  default     = {}
  description = "A map of Kubernetes labels to apply to nodes in the default AKS node pool. Changing this value forces the node pool to be recreated."
}

variable "automatic_channel_upgrade" {
  type        = string
  default     = "patch"
  description = <<EOT
The automatic upgrade channel to use for the AKS cluster. Determines how the cluster is updated with newer Kubernetes versions.
Allowed values:
  - "patch"       → Only automatic patch updates within the same minor version.
  - "stable"      → Recommended channel for general workloads. Upgrades through stable minor versions.
  - "rapid"       → For testing the latest versions quickly.
  - "node-image"  → Only the node OS and container runtime get updated, Kubernetes version stays the same.
  - "none"        → Disables automatic upgrades. Manual upgrades are required.
EOT
}

variable "ebpf_data_plane" {
  type        = string
  default     = "none"
  description = <<EOT
Specifies the eBPF data plane implementation for the AKS cluster.
Allowed values:
  - "none"     : Disable eBPF data plane (default kube-proxy)
  - "cilium"   : Enable Cilium as the eBPF data plane
EOT
}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "Specifies the type of managed identity used for the AKS cluster. Allowed values are 'SystemAssigned' or 'UserAssigned'."
}

variable "net_profile_pod_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block used for pod IP addresses in the AKS cluster. Required when using kubenet or overlay network plugin."
}

variable "net_profile_service_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block used for Kubernetes service IPs in the AKS cluster."
}

variable "network_ip_versions" {
  type        = list(string)
  default     = ["IPv4"]
  description = "Specifies the IP version used in the AKS cluster. Allowed values are 'IPv4' or 'IPv6'."
}

variable "network_plugin_mode" {
  type        = string
  default     = "overlay"
  description = "Specifies the network plugin mode. 'overlay' is used with the Azure CNI Overlay plugin."
}

variable "only_critical_addons_enabled" {
  type        = bool
  default     = true
  description = "Enable this setting to allow only critical addons to run on the system node pool, improving system isolation and performance."
}

variable "rbac_aad_tenant_id" {
  type        = string
  default     = null
  description = "The Azure AD tenant ID to use for Kubernetes RBAC integration. If null, the default tenant is used."
}

variable "rbac_aad_azure_rbac_enabled" {
  type        = bool
  default     = null
  description = "Whether to enable Azure RBAC for Kubernetes authorization. If null, the provider default is used."
}

variable "net_profile_dns_service_ip" {
  type        = string
  default     = "10.100.0.10"
  description = "The IP address within the service CIDR to use for the Kubernetes DNS service (kube-dns/CoreDNS). Must be within the net_profile_service_cidr range."
}

variable "agents_availability_zones" {
  type        = list(string)
  default     = null
  description = "List of Availability Zones for the AKS agent pool. Zones must be supported in the selected region and for the chosen VM size. Leave empty to disable zonal distribution."
}

variable "workload_identity_enabled" {
  description = "Enable Azure AD Workload Identity on the AKS cluster. This allows pods to use federated identity to access Azure resources securely."
  type        = bool
  default     = true
}

variable "karpenter_identity_name" {
  type        = string
  default     = "karpentermsi"
  description = "Name of the user-assigned managed identity."
}

variable "register_container_service" {
  description = "Controls whether to register the Microsoft.ContainerService resource provider."
  type        = bool
  default     = false
}

variable "karpenter_roles" {
  description = "List of built-in roles to assign to the Karpenter MSI"
  type        = list(string)
  default = [
    "Virtual Machine Contributor",
    "Network Contributor",
    "Managed Identity Operator"
  ]
}

variable "karpenter_namespace" {
  description = "Namespace where Karpenter will be installed"
  type        = string
  default     = "kube-system"
}

variable "karpenter_crds_chart_version" {
  description = "Version of the Karpenter crds Helm chart"
  type        = string
  default     = ""
}

variable "karpenter_version" {
  type    = string
  default = ""
}

variable "os_disk_size_gb" {
  description = "The size of the OS disk in gigabytes for the virtual machine."
  type        = number
  default     = 50
}

variable "maintenance_window" {
  description = "Specifies the allowed and not allowed maintenance windows. 'allowed' defines specific days and hours, while 'not_allowed' defines exact time ranges in UTC where maintenance should not occur."
  type = object({
    allowed = list(object({
      day   = string
      hours = list(number)
    }))
    not_allowed = list(object({
      start = string
      end   = string
    }))
  })
  default = {
    allowed = [
      {
        day   = "Sunday"
        hours = [22, 23]
      }
    ]
    not_allowed = [
      {
        start = "2035-01-01T20:00:00Z"
        end   = "2035-01-01T21:00:00Z"
      }
    ]
  }
}

variable "key_vault_secrets_provider_enabled" {
  description = "Enable integration with Azure Key Vault Secrets Provider to mount secrets into pods."
  type        = bool
  default     = true
}

variable "private_cluster_enabled" {
  description = "Specifies whether the AKS cluster is private (API server accessible only within virtual network)."
  type        = bool
  default     = true
}

variable "enable_host_encryption" {
  description = "Specifies whether host-based encryption is enabled for nodes in the AKS cluster."
  type        = bool
  default     = true
}

variable "kms_enabled" {
  description = "Enable Azure Key Management Service (KMS) for secret encryption at rest in the AKS cluster."
  type        = bool
  default     = true
}

variable "kms_key_vault_network_access" {
  description = "Specifies the network access level for the Key Vault used by KMS. Possible values: 'private' or 'public'."
  type        = string
  default     = "public"
}

variable "secret_rotation_enabled" {
  description = "Is secret rotation enabled? This variable is only used when `key_vault_secrets_provider_enabled` is `true`."
  type        = bool
  default     = false
}

variable "secret_rotation_interval" {
  description = "The interval to poll for secret rotation. This is only used when `secret_rotation_enabled` is `true`."
  type        = string
  default     = "2m"
}


variable "karpenter_resources" {
  description = "CPU and memory requests and limits for the Karpenter controller"
  type = object({
    request_cpu    = string
    request_memory = string
    limit_memory   = string
  })

  default = {
    request_cpu    = "200m"
    request_memory = "512Mi"
    limit_memory   = "512Mi"
  }
}

variable "bootstrap_token_secret_name" {
  type        = string
  description = "Name of the bootstrap token secret in kube-system namespace"
  default     = ""
}

variable "karpenter_service_account_name" {
  description = "The name of the Karpenter service account"
  type        = string
  default     = "karpenter-controller-sa"
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted Key Vaults before permanent deletion."
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled on the Key Vault (required for Disk Encryption Set)."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable or disable public network access to the Key Vault."
  type        = bool
  default     = true
}

variable "enabled_for_disk_encryption" {
  description = "Enable the Key Vault to be used with Azure Disk Encryption."
  type        = bool
  default     = true
}

variable "enable_rbac_authorization" {
  description = "Whether to enable Role-Based Access Control (RBAC) authorization for the Key Vault."
  type        = bool
  default     = true
}

variable "enabled_for_template_deployment" {
  description = "Specifies if the Key Vault is available for template deployment."
  type        = bool
  default     = true
}

variable "enabled_for_deployment" {
  description = "Specifies if the Key Vault is enabled for use in deployment."
  type        = bool
  default     = true
}

variable "key_vault_sku_name" {
  description = "The SKU name of the Key Vault. Possible values are 'standard' and 'premium'."
  type        = string
  default     = "standard"
}

variable "key_vault_key_type" {
  description = "The type of key to create in Key Vault. Possible values are 'RSA', 'RSA-HSM', 'EC', 'EC-HSM'."
  type        = string
  default     = "RSA"
}

variable "key_vault_key_size" {
  description = "The size of the RSA key to create. Required only for RSA or RSA-HSM."
  type        = number
  default     = 2048
}

variable "key_vault_key_create_duration" {
  description = "The duration after which the key will be created in the Key Vault. Format should be a duration string (e.g. '120s')."
  type        = string
  default     = "120s"
}

variable "key_vault_key_auto_rotation_enabled" {
  description = "Specifies whether automatic key rotation is enabled for the Key Vault key."
  type        = bool
  default     = true
}

variable "key_vault_role_definition_name" {
  description = "The built-in role definition name to assign for the Key Vault access."
  type        = string
  default     = "Key Vault Administrator"
}

variable "key_vault_key_opts" {
  description = <<EOT
A list of operations permitted on the Key Vault key.
Valid values include:
- "decrypt"
- "encrypt"
- "sign"
- "unwrapKey"
- "verify"
- "wrapKey"
EOT

  type = list(string)
  default = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

variable "key_expiration_offset" {
  description = "The duration (e.g., '1h', '24h', '720h') to add to the current timestamp to set the key expiration date."
  type        = string
  default     = "8760h"
}

variable "key_vault_node_role_definition_name" {
  description = "The role name used for node pool access to Key Vault for disk encryption."
  type        = string
  default     = "Key Vault Crypto Service Encryption User"
}

variable "key_vault_ip_rules" {
  description = "List of IP addresses allowed to access the key vault"
  type        = list(string)
  default     = ["185.209.237.16"]
}

variable "nat_gateway_sku_name" {
  description = "The SKU of the NAT Gateway"
  type        = string
  default     = "Standard"
}

variable "public_ip_allocation_method" {
  description = "The allocation method for the public IP"
  type        = string
  default     = "Static"
}

variable "public_ip_sku" {
  description = "The SKU of the public IP (Standard is required for NAT Gateway)"
  type        = string
  default     = "Standard"
}

variable "idle_timeout_in_minutes" {
  description = "Idle timeout in minutes for NAT Gateway"
  type        = number
  default     = 10
}

variable "karpenter_subnet_role_definition" {
  type        = string
  description = "Role definition name or ID to assign on the subnets"
  default     = "Network Contributor"
}

variable "auto_scaler_profile_enabled" {
  description = "Whether the auto scaler profile is enabled"
  type        = bool
  default     = true
}

variable "auto_scaler_profile_skip_nodes_with_local_storage" {
  description = "Whether to skip nodes with local storage"
  type        = bool
  default     = false
}

variable "auto_scaler_profile_skip_nodes_with_system_pods" {
  description = "Whether to skip nodes with system pods"
  type        = bool
  default     = false
}

variable "auto_scaler_profile_balance_similar_node_groups" {
  description = "Detect similar node groups and balance the number of nodes between them"
  type        = bool
  default     = false
}

variable "auto_scaler_profile_expander" {
  description = "Auto-scaler profile expander setting. Possible values are least-waste, priority, most-pods, and random. Defaults to random."
  type        = string
  default     = "random"
  validation {
    condition     = contains(["least-waste", "priority", "most-pods", "random"], var.auto_scaler_profile_expander)
    error_message = "Allowed values for auto_scaler_profile_expander are least-waste, priority, most-pods, and random."
  }
}

variable "node_pools" {
  description = "Map of node pools with configuration"
  type = map(object({
    name                = string
    vm_size             = string
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    node_taints         = list(string)
    os_disk_size_gb     = number
    max_pods            = number
    mode                = string
    priority            = string
    os_type             = string
    node_labels         = map(string)
  }))
  default = {}
}

variable "nat_gateway_zone" {
  type        = string
  default     = "1"
  description = "The availability zone in which to deploy the NAT Gateway"
}
