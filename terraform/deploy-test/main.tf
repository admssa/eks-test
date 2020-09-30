module "deployment" {
  source = "../modules/depoyment-generic"
  name = "aws-cli-test"
  namespace = local.sa_namespace
  container_name = "aws-cli"
  container_image = "amazon/aws-cli:2.0.53"
  sa_name = local.sa_name
  sa_role_arn = module.sa_role_test.role_arn
}