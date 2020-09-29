variable "cluster_name" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "subnets" {
  default = []
}

variable "admins_role_arn" {
  default = ""
}

variable "api_is_private" {
  default = false
}

variable "security_groups" {
  default = []
}

variable "api_allowed_cidrs" {
  default = []
}

variable "logs_enabled" {
  default = []
}

variable "tags" {
  default = {}
}