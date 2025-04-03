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

variable "node_pools" {
  description = "Map of node pools with configuration"
  type = map(object({
    name                = string
    vm_size             = string
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    taints              = list(string)
    labels              = map(string)
  }))
  default = {}
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
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
  default     = []
}

variable "private_cluster_public_fqdn_enabled" {
  description = "Enable public FQDN for private cluster"
  type        = bool
  default     = false
}