
data "aws_iam_policy_document" "sa_assume_role_policy" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.serviceaccount_namespace}:${var.serviceaccount_name}"]
    }

    principals {
      identifiers = [var.oidc_arn]
      type        = "Federated"
    }
  }
}


resource "aws_iam_role" "sa_assume_role" {
  count              = var.enabled ? 1 : 0
  path               = "/${var.cluster_name}/${var.serviceaccount_namespace}/"
  assume_role_policy = data.aws_iam_policy_document.sa_assume_role_policy[0].json
  name               = "eks-${var.cluster_name}-${var.serviceaccount_namespace}-${var.serviceaccount_name}"
}


resource "aws_iam_policy" "sa_policy" {
  count       = var.enabled ? length(var.policies) : 0
  description = "IAM policy for EKS cluster: ${var.cluster_name}, serviceaccount: ${var.serviceaccount_name}"
  path        = "/${var.cluster_name}/${var.serviceaccount_namespace}/"
  name_prefix = var.serviceaccount_name
  policy      = var.policies[count.index]
}

resource "aws_iam_role_policy_attachment" "sa_role_attachment" {
  count      = var.enabled ? length(var.policies) : 0
  policy_arn = aws_iam_policy.sa_policy[count.index].arn
  role       = aws_iam_role.sa_assume_role[0].name
}

resource "aws_iam_role_policy_attachment" "policy_arns" {
  count      = var.enabled ? length(var.policy_arns) : 0
  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.sa_assume_role[0].name
}