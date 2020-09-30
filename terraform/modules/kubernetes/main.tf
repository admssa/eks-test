module "eks-subnets" {
  source = "../eks-subnets"

  cluster_name             = var.cluster_name
  vpc_id                   = var.vpc_id
  private_subnets_prefixes = var.private_subnets_prefixes
  public_subnets_prefixes  = var.public_subnets_prefixes
  common_tags              = var.common_tags
  eks_tags                 = var.eks_tags
}

module "eks-cluster" {
  source            = "../eks-cluster"
  cluster_name      = var.cluster_name
  vpc_id            = var.vpc_id
  subnets           = module.eks-subnets.private_subnet_ids
  api_allowed_cidrs = var.api_allowed_cidrs
}

module "eks-nodes" {
  source            = "../eks-nodes"
  cluster_name      = var.cluster_name
  ssh_key           = var.ssh_key
  vpc_id            = var.vpc_id
  subnets           = module.eks-subnets.private_subnet_ids
  node_groups       = var.node_groups
  disk_size         = var.disk_size
  module_depends_on = module.eks-cluster.endpoint
}