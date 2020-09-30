variable "cluster_name" {
  default = ""
}
variable "vpc_id" {
  default = ""
}
variable "private_subnets_prefixes" {
  default = ""
}
variable "public_subnets_prefixes" {
  default = ""
}
variable "common_tags" {
  default = ""
}
variable "eks_tags" {
  default = ""
}

variable "ssh_key" {
  default = ""
}

variable "node_groups" {
  default = []
}

variable "api_allowed_cidrs" {
  default = ["0.0.0.0/0"]
}

variable "disk_size" {
  default = 20
}