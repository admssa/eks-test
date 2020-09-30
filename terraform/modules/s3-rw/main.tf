locals {
  bucket_resources = sort(distinct(data.null_data_source.buckets.*.outputs.bucket_arn))
  object_resources = sort(distinct(data.null_data_source.objects.*.outputs.object_arn))
  enabled          = length(var.s3_paths) > 0
}

data "aws_iam_policy_document" "main" {
  count = local.enabled ? 1 : 0
  statement {
    sid    = "Global"
    effect = "Allow"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "BucketRWAccess"
    effect = "Allow"

    actions = [
      "s3:GetBucketWebsite",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
    ]

    resources = local.bucket_resources
  }

  statement {
    sid    = "ObjectRWAccess"
    effect = "Allow"

    actions = [
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListObjectsV2",
      "s3:AbortMultipartUpload",
      "s3:GetObjectTorrent",
    ]

    resources = local.object_resources
  }
}

resource "aws_iam_user_policy" "s3_user_policy" {
  count  = local.enabled && var.user != "" ? 1 : 0
  name   = var.name
  policy = data.aws_iam_policy_document.main[0].json
  user   = var.user
}

resource "aws_iam_role_policy" "s3_role_policy" {
  count  = local.enabled && var.role != "" ? 1 : 0
  name   = var.name
  policy = data.aws_iam_policy_document.main[0].json
  role   = var.role
}

resource "aws_iam_group_policy" "group_policy" {
  count  = local.enabled && var.group != "" ? 1 : 0
  name   = var.name
  policy = data.aws_iam_policy_document.main[0].json
  group  = var.group
}

resource "aws_iam_policy" "managed_policy" {
  count  = local.enabled && var.managed ? 1 : 0
  name   = var.name
  policy = data.aws_iam_policy_document.main[0].json
}
