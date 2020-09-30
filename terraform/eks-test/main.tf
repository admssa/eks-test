
module "kubernetes" {
  source                   = "../modules/kubernetes"
  cluster_name             = var.cluster_name
  vpc_id                   = var.vpc_id
  private_subnets_prefixes = var.private_subnets_prefixes
  public_subnets_prefixes  = var.public_subnets_prefixes
  common_tags              = local.common_tags
  eks_tags                 = local.eks_tags
  ssh_key                  = var.ssh_key
  node_groups              = local.node_groups
}