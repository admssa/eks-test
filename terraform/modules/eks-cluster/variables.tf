variable "cluster_name" {
}

variable "cluster_version" {
  default = "1.17"
}

variable "vpc_id" {
}

variable "subnets" {
  default = []
}

variable "api_is_private" {
  default = false
}

variable "security_groups" {
  default = []
}

variable "api_allowed_cidrs" {
  default = ["0.0.0.0/0"]
}

variable "logs_enabled" {
  default = []
}

variable "tags" {
  default = {}
}