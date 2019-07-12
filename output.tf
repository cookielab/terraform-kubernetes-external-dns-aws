output "aws_iam_policy_arn" {
  value = var.aws_create_policy ? aws_iam_policy.external_dns.0.arn : null
}

output "kubernetes_deployment" {
  value = "${kubernetes_deployment.external_dns.metadata.0.namespace}/${kubernetes_deployment.external_dns.metadata.0.name}"
}
