output "json" {
  description = "Policy JSON"
  value       = element(concat(data.aws_iam_policy_document.main.*.json, [""]), 0)
}

output "policy_arn" {
  description = "Managed policy ARN. It's actual if it's managed."
  value       = "arn:aws:iam::${local.account_id}:policy/${var.name}"
}

output "policy_name" {
  description = "Managed policy name. It's actual if it's managed."
  value       = var.name
}
