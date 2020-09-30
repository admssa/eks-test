module "sa_role_test" {
  source                   = "../modules/eks-sa-role"
  cluster_name             = data.terraform_remote_state.eks.outputs.cluster_name
  enabled                  = true
  serviceaccount_name      = local.sa_name
  serviceaccount_namespace = local.sa_namespace
  oidc_arn                 = data.terraform_remote_state.eks.outputs.oidc_arn
  oidc_url                 = data.terraform_remote_state.eks.outputs.oidc_url
  policies                 = [ ]
}


module "test_s3_rw" {
  source   = "../modules/s3-rw"
  role     = module.sa_role_test.role_name
  s3_paths = var.test_s3_paths
}
