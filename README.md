# Terraform module for Kubernetes External DNS on AWS

This module deploys [External DNS](https://github.com/kubernetes-sigs/external-dns) for AWS to your Kubernetes cluster.

## Usage

```terraform
provider "kubernetes" {
  # your kubernetes provider config
}

provider "aws" {
  # your aws provider config
}

data "aws_iam_role" "kubernetes_worker_node" {
  name = "kube-clb-main-wg-primary"
}

module "kubernetes_dashboard" {
  source = "cookielab/external-dns-aws/kubernetes"
  version = "0.9.0"

  domains = [
    "cookielab.io"
  ]

  sources = [
    "ingress"
  ]

  owner_id = "kube-clb-main"
  aws_iam_role_for_policy = data.aws_iam_role.kubernetes_worker_node.name
}
```
