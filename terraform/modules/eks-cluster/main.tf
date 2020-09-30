
data "aws_region" "current" {}
data "external" "thumbprint" {
  program = ["${path.module}/bin/get_thumbprint.sh", data.aws_region.current.name]
}

resource "aws_eks_cluster" "this" {
  name                      = var.cluster_name
  enabled_cluster_log_types = var.logs_enabled
  version                   = var.cluster_version

  vpc_config {
    subnet_ids              = var.subnets
    endpoint_private_access = var.api_is_private
    endpoint_public_access  = var.api_is_private ? false : true
    security_group_ids      = var.security_groups
  }
  role_arn = aws_iam_role.eks_cluster_role.arn
  tags     = var.tags
}

resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 30
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: "${aws_eks_cluster.this.endpoint}"
    certificate-authority-data: "${aws_eks_cluster.this.certificate_authority.0.data}"
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
KUBECONFIG
}
