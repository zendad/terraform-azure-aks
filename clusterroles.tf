# clustor role AD rbac_bindings
resource "azurerm_role_assignment" "aks_rbac_cluster_admin" {
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  scope                = module.aks.aks_id
}

resource "helm_release" "rbac_bindings" {
  name      = "cluster-roles"
  chart     = "${path.module}/templates/roles/cluster-roles"
  namespace = "kube-system"

  values = [
    yamlencode({
      clusterroleGroups = {
        for role in local.cluster_roles :
        role => {
          id = "/groups/${data.azuread_group.k8s_groups[role].object_id}"
        }
      }
    })
  ]
}



