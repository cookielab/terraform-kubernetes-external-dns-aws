resource "kubernetes_service_account" "external_dns" {
  metadata {
    name = "${var.kubernetes_resources_name_prefix}external-dns"
    namespace = var.kubernetes_namespace
    labels = local.kubernetes_resources_labels
  }
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "${var.kubernetes_resources_name_prefix}external-dns"
    labels = local.kubernetes_resources_labels
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
    name = "${var.kubernetes_resources_name_prefix}external-dns"
    labels = local.kubernetes_resources_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.external_dns.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.external_dns.metadata.0.name
    namespace = kubernetes_service_account.external_dns.metadata.0.namespace
  }
}

resource "kubernetes_deployment" "external_dns" {
  metadata {
    name = "${var.kubernetes_resources_name_prefix}external-dns"
    namespace = var.kubernetes_namespace
    labels = local.kubernetes_resources_labels
  }

  spec {
    selector {
      match_labels = local.kubernetes_deployment_labels_selector
    }

    template {
      metadata {
        labels = local.kubernetes_deployment_labels
        annotations = var.kubernetes_deployment_annotations
      }

      spec {
        service_account_name = kubernetes_service_account.external_dns.metadata.0.name

        container {
          image = local.kubernetes_deployment_image
          name = "external-dns"

          args = local.kubernetes_deployment_container_args

          volume_mount { # hack for automountServiceAccountToken
            name = kubernetes_service_account.external_dns.default_secret_name
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            read_only = true
          }
        }

        volume { # hack for automountServiceAccountToken
          name = kubernetes_service_account.external_dns.default_secret_name
          secret {
            secret_name = kubernetes_service_account.external_dns.default_secret_name
          }
        }

        node_selector = var.kubernetes_deployment_node_selector
      }
    }
  }
}
