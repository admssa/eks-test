output "node_grpups" {
  value = aws_eks_node_group.this.*.arn
}

output "autoscaling_groups" {
  value = aws_eks_node_group.this.*.resources
}