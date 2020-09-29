resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-cluster"
  description = "EKS cluster Security group"

  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_from_subnets" {
  count             = length(var.api_allowed_cidrs) > 0 ? 1 : 0
  from_port         = 443
  protocol          = "TCP"
  cidr_blocks       = var.api_allowed_cidrs
  to_port           = 443
  type              = "ingress"
  security_group_id = aws_security_group.eks_cluster_sg.id
  description       = "Allow  access to API from additional subnets"
}