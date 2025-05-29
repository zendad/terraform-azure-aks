subscription_id = ""
location        = "germanywestcentral"
environment     = "test"

default_tags = {
  env     = "test"
  owner   = "Infrastructure"
  contact = "infra@dereckzenda.com"
  dept    = "DevOps"
}

kubernetes_version                              = "1.32"
vnet_cidr                                       = "10.0.0.0/16"
availability_zones                              = ["1", "2", "3"]
network_plugin                                  = "azure"
network_policy                                  = "calico"
auto_scaler_profile_expander                    = "least-waste"
auto_scaler_profile_balance_similar_node_groups = true
node_pools = {
  tooling_nodes = {
    name                = "tooling"
    vm_size             = "Standard_D2s_v3"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 6
    max_pods            = 150
    mode                = "System"
    os_type             = "Linux"
    os_disk_size_gb     = 50
    priority            = "Regular"
    node_taints         = ["CriticalAddonsOnly=true:NoSchedule"]
    node_labels = {
      "role" = "tooling"
      "apps" = "tooling"
    }
  },
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