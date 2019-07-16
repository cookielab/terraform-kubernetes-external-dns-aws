output "aws_iam_policy_arn" {
  value = length(aws_iam_policy.external_dns) == 0 ? null : aws_iam_policy.external_dns.0.arn
}

output "kubernetes_deployment" {
  value = "${kubernetes_deployment.external_dns.metadata.0.namespace}/${kubernetes_deployment.external_dns.metadata.0.name}"
}
