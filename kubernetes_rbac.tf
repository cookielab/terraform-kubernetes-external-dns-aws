resource "kubernetes_service_account" "external_dns" {
  metadata {
    name = var.kubernetes_service_account_name
    namespace = var.kubernetes_namespace
  }
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = var.kubernetes_cluster_role_name
  }

  rule {
    api_groups = [""]
    resources = ["services"]
    verbs = ["get","watch","list"]
  }

  rule {
    api_groups = [""]
    resources = ["pods"]
    verbs = ["get","watch","list"]
  }

  rule {
    api_groups = ["extensions"]
    resources = ["ingresses"]
    verbs = ["get","watch","list"]
  }

  rule {
    api_groups = [""]
    resources = ["nodes"]
    verbs = ["list","watch"]
  }
}

resource "kubernetes_cluster_role_binding" "external_dns" {
  metadata {
    name = var.kubernetes_cluster_role_binding_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "${kubernetes_cluster_role.external_dns.metadata.0.name}"
  }

  subject {
    kind = "ServiceAccount"
    name = "${kubernetes_service_account.external_dns.metadata.0.name}"
    namespace = "${kubernetes_service_account.external_dns.metadata.0.namespace}"
  }
}
