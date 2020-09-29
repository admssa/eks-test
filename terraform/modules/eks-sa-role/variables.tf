variable "oidc_url" {
  default = ""
}
variable "oidc_arn" {
  default = ""
}

variable "cluster_name" {
  default = ""
}
variable "serviceaccount_name" {
  default = ""
}

variable "serviceaccount_namespace" {
  default = ""
}

variable "enabled" {
  default = false
}

variable "policies" {
  default = []
}

variable "policy_arns" {
  default = []
}