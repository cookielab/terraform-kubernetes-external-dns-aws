variable "policy" {
  type = string
  default = "upsert-only"
  description = "Policy for creating or updating records. Possible values: sync - allows for full synchronization of DNS records or upsert-only - allows evrything but deleting DNS records."
}

variable "domains" {
  type = list(string)
  default = []
  description = "Will make see only the hosted zones matching provided domain, omit to process all available hosted zones."
}

variable "zone_type" {
  type = string
  default = "public"
  description = "Set public for public DNS zone or private for private DNS zone or ommit this var for both."
}

variable "sources" {
  type = list(string)
  default = ["ingress", "service"]
  description = "What resouces should be mapped by this service. Possible values ingress, service or both."
}

variable "owner_id" {
  type = string
  default = "kube-external-dns"
  description = "Value of TXT record for detection zone records managed by this service."
}

variable "kubernetes_namespace" {
  type = string
  default = "kube-system"
  description = "Kubernetes namespace to deploy external dns."
}

variable "kubernetes_namespace_create" {
  type = bool
  default = false
  description = "Do you want to create kubernetes namespace?"
}

variable "kubernetes_resources_name_prefix" {
  type = string
  default = ""
  description = "Prefix for kubernetes resources name. For example `tf-module-`"
}

variable "kubernetes_resources_labels" {
  type = map(string)
  default = {}
  description = "Additional labels for kubernetes resources."
}

variable "kubernetes_deployment_image_registry" {
  type = string
  default = "registry.opensource.zalan.do/teapot/external-dns"
}

variable "kubernetes_deployment_image_tag" {
  type = string
  default = "v0.5.15"
}

variable "kubernetes_deployment_node_selector" {
  type = map(string)
  default = {}
  description = "Node selectors for kubernetes deployment"
}

variable "aws_create_iam_policy" {
  type = bool
  default = true
  description = "Do you want to create IAM policy?"
}

variable "aws_iam_policy_name" {
  type = string
  default = "KubernetesExternalDNS"
  description = "Name of AWS IAM policy."
}

variable "aws_iam_role_for_policy" {
  type = string
  default = null
  description = "AWS role name for attaching IAM policy"
}

variable "kubernetes_deployment_annotations" {
  type = map(string)
  default = {}
  description = "Annotations for pod template"
}
