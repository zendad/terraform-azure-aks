subscription_id = ""
location        = "germanywestcentral"
environment     = "test"

# tags
default_tags = {
  environment = "Dev"
  owner       = "Infrastructure"
  contact     = "CorePlatform"
  project     = "CorePlatform"
  costcenter  = "containerplatform"
  application = "platform-services"
  managedby   = "Terraform"
  gitlab      = ""
}

# agent node labels
agents_labels = {
  environment = "Dev"
  owner       = "Infrastructure"
  contact     = "CorePlatform"
  project     = "CorePlatform"
  costcenter  = "containerplatform"
}

kubernetes_version                              = "1.32"
vnet_cidr                                       = "10.0.0.0/16"
availability_zones                              = ["1", "2", "3"]
network_plugin                                  = "azure"
network_policy                                  = "calico"
auto_scaler_profile_expander                    = "least-waste"
auto_scaler_profile_balance_similar_node_groups = true

enable_auto_scaling = true
agents_min_count    = 1
agents_max_count    = 5
os_disk_size_gb     = 60

key_vault_secrets_provider_enabled = true
kms_enabled                        = true
kms_key_vault_network_access       = "public"
private_cluster_enabled            = false
secret_rotation_enabled            = true
secret_rotation_interval           = "3600m"
key_vault_ip_rules                 = ["185.209.237.248"]


node_pools = {
  workload_nodes = {
    name                = "workload"
    vm_size             = "Standard_D2s_v3"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 10
    max_pods            = 150
    os_disk_size_gb     = 50
    os_type             = "Linux"
    priority            = "Regular"
    mode                = "User"
    node_taints         = []
    node_labels = {
      "role" = "workload"
      "apps" = "workload"
    }
  }
}
