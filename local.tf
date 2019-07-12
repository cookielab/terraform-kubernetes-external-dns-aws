locals {
  kubernetes_resources_labels = merge({
    "cookielab.io/terraform-module" = "aws-kube-external-dns",
  }, var.kubernetes_resources_labels)

  kubernetes_deployment_labels_selector = {
    "cookielab.io/deployment" = "aws-kube-external-dns-tf-module",
  }

  kubernetes_deployment_labels = merge(local.kubernetes_deployment_labels_selector, local.kubernetes_resources_labels)

  kubernetes_deployment_image = "${var.kubernetes_deployment_image_registry}:${var.kubernetes_deployment_image_tag}"


  kubernetes_deployment_container_args_sources = formatlist("--source=%s", var.sources)
  kubernetes_deployment_container_args_domains = formatlist("--domain-filter=%s", var.domains)
  kubernetes_deployment_container_args_base = [
    "--provider=aws",
    "--policy=${var.policy}",
    "--aws-zone-type=${var.zone_type}",
    "--registry=txt",
    "--txt-owner-id=${var.owner_id}",
  ]

  kubernetes_deployment_container_args = concat(
    local.kubernetes_deployment_container_args_sources,
    local.kubernetes_deployment_container_args_domains,
    local.kubernetes_deployment_container_args_base
  )
}
