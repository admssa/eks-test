data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "${path.module}/../eks-test/terraform.tfstate"
  }
}