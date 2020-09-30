data "null_data_source" "buckets" {
  count = length(var.s3_paths)

  inputs = {
    bucket_name = element(split("/", var.s3_paths[count.index]), 0)
    bucket_arn  = "arn:aws:s3:::${element(split("/", var.s3_paths[count.index]), 0)}"
  }
}

data "null_data_source" "objects" {
  count = length(var.s3_paths)

  inputs = {
    object_name = element(var.s3_paths, count.index)
    object_arn  = "arn:aws:s3:::${var.s3_paths[count.index]}"
  }
}

output "bucket_names" {
  value = sort(distinct(data.null_data_source.buckets.*.outputs.bucket_name))
}

output "bucket_arns" {
  value = sort(distinct(data.null_data_source.buckets.*.outputs.bucket_arn))
}

output "object_names" {
  value = sort(distinct(data.null_data_source.objects.*.outputs.object_name))
}

output "object_arns" {
  value = sort(distinct(data.null_data_source.objects.*.outputs.object_arn))
}
