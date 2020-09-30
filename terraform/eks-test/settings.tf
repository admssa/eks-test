
locals {
  common_tags = map(
    "Environment", var.cluster_name,
    "Developed", "Sergii Shapovalenko"
  )
  eks_tags = map(
    "KubernetesCluster", var.cluster_name,
    "kubernetes.io/cluster/${var.cluster_name}", "shared",
  )
  node_groups = [
    {
      instance  = "t3.medium"
      n_min     = 1
      n_max     = 1
      n_desired = 1
      ami_type  = "AL2_x86_64"
    }
  ]
}