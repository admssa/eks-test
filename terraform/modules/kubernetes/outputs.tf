output "kubeconfig" {
  value = module.eks-cluster.kubeconfig
}

output "cluster_ca" {
  value = module.eks-cluster.ca
}

output "cluster_ednpoint" {
  value = module.eks-cluster.endpoint
}

output "oidc_arn" {
  value = module.eks-cluster.oidc_arn
}

output "oidc_url" {
  value = module.eks-cluster.oidc_url
}
