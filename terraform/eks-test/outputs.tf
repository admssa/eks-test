output "kubeconfig" {
  value = module.kubernetes.kubeconfig
}

output "oidc_url" {
  value = module.kubernetes.oidc_url
}

output "oidc_arn" {
  value = module.kubernetes.oidc_arn
}

output "cluster_ednpoint" {
  value = module.kubernetes.cluster_ednpoint
}

output "cluster_ca" {
  value = module.kubernetes.cluster_ca
}

output "cluster_name" {
  value = var.cluster_name
}