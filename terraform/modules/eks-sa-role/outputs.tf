output "role_arn" {
  value = element(concat(aws_iam_role.sa_assume_role.*.arn, [""]), 0)
}

output "sa_name" {
  value = var.serviceaccount_name
}

output "sa_namespace" {
  value = var.serviceaccount_namespace
}

output "role_name" {
  value = element(concat(aws_iam_role.sa_assume_role.*.name, [""]), 0)
}