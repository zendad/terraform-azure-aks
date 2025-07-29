/*
# Cluster role binding
resource "kubernetes_manifest" "cluster_roles" {
  for_each = fileset("${path.module}/templates", "*.yaml")

  manifest = yamldecode(file("${path.module}/templates/${each.value}"))
}

resource "kubernetes_cluster_role_binding" "cluster_bindings" {
  depends_on = [kubernetes_manifest.cluster_roles]
  for_each   = data.azuread_group.k8s_groups

  metadata {
    name = "${each.key}-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.key
  }

  subject {
    kind      = "Group"
    name      = trim(replace(each.value.id, "/groups/", ""), "/")
    api_group = "rbac.authorization.k8s.io"
  }
}

*/
