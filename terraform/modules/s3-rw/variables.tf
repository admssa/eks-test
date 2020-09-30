variable "name" {
  description = "Policy name."
  default     = "s3-rw-access"
}

variable "user" {
  description = "IAM User to attach inline inline policy."
  default     = ""
}

variable "role" {
  description = "IAM Role to attach inline inline policy."
  default     = ""
}

variable "group" {
  description = "IAM Group to attach inline inline policy."
  default     = ""
}

variable "managed" {
  default = false
}

variable "s3_paths" {
  description = "List of S3 paths to grant the access."
  default     = []
}
