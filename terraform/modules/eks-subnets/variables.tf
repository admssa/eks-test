variable "common_tags" {
  default = {}
}
variable "eks_tags" {
  default = {}
}
variable "public_subnets_prefixes" {
  default = []
}
variable "single_nat_gw" {
  default = true
}

variable "private_subnets_prefixes" {
  default = []
}

variable "cluster_name" {
}

variable "vpc_id" {

}