locals {
    kube_container_args_sources = formatlist("--source=%s", var.sources)
    kube_container_args_domains = formatlist("--domain-filter=%s", var.domains)
    kube_container_args_base = [
        "--provider=aws",
        "--policy=${var.policy}",
        "--aws-zone-type=${var.zone_type}",
        "--registry=txt",
        "--txt-owner-id=${var.owner_id}",
    ]

    kube_container_args = concat(local.kube_container_args_sources, local.kube_container_args_domains, local.kube_container_args_base)
}
