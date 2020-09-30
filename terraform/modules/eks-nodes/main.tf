
resource "aws_eks_node_group" "this" {
  count           = length(var.node_groups)
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-${replace(lookup(var.node_groups[count.index], "instance"), ".", "-")}"
  node_role_arn   = aws_iam_role.workers.arn
  subnet_ids      = var.subnets
  disk_size       = var.disk_size
  ami_type        = lookup(var.node_groups[count.index], "ami_type")
  instance_types  = [lookup(var.node_groups[count.index], "instance")]

  scaling_config {
    desired_size = lookup(var.node_groups[count.index], "n_desired")
    max_size     = lookup(var.node_groups[count.index], "n_min")
    min_size     = lookup(var.node_groups[count.index], "n_max")
  }
  remote_access {
    ec2_ssh_key = var.ssh_key
  }
  tags = {
    "Name"                                                                = "${var.cluster_name}-${replace(lookup(var.node_groups[count.index], "instance"),".","-")}"
    "kubernetes.io/cluster/${var.cluster_name}"                           = "owned",
    "k8s.io/cluster-autoscaler/node-template/resources/ephemeral-storage" = "${var.disk_size}Gi",
    "k8s.io/cluster-autoscaler/enabled"                                   = "true"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
