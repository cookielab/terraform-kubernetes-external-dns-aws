resource "kubernetes_deployment" "external_dns" {
  metadata {
    name = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels = {
      app = "tf-aws-kube-external-dns"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "tf-aws-kube-external-dns"
      }
    }

    template {
      metadata {
        labels = {
          app = "tf-aws-kube-external-dns"
        }
      }

      spec {
        service_account_name = "${kubernetes_service_account.external_dns.metadata.0.name}"

        container {
          image = "${var.external_dns_image_registry}:${var.external_dns_image_tag}"
          name = "external-dns"

          args = local.kube_container_args

          volume_mount { # hack for automountServiceAccountToken
            name = "${kubernetes_service_account.external_dns.default_secret_name}"
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            read_only = true
          }
        }

        volume { # hack for automountServiceAccountToken
          name = "${kubernetes_service_account.external_dns.default_secret_name}"
          secret {
            secret_name = "${kubernetes_service_account.external_dns.default_secret_name}"
          }
        }
      }
    }
  }
}
