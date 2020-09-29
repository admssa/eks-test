output "kubeconfig" {
  value = local.kubeconfig
}

output "ca" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "security_group" {
  value = aws_security_group.eks_cluster_sg.id
}

output "oidc_url" {
  value = aws_iam_openid_connect_provider.eks.url
}

output "oidc_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}