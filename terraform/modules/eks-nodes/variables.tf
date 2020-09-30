variable "cluster_name" {
}

variable "vpc_id" {

}

variable "node_groups" {
  default = []
}

variable "subnets" {
  default = []
}

variable "disk_size" {
  default = 20
}

variable "ssh_key" {

}

variable "module_depends_on" {

}