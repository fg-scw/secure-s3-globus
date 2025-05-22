output "bucket_name" {
  value = scaleway_object_bucket.bucket.name
}

output "sse_c_key" {
  value     = local.sse_c_key
  sensitive = true
}

output "write_app_access_key" {
  value     = scaleway_iam_api_key.write_key.access_key
  sensitive = true
}

output "write_app_secret_key" {
  value     = scaleway_iam_api_key.write_key.secret_key
  sensitive = true
}

output "read_app_access_key" {
  value     = scaleway_iam_api_key.read_key.access_key
  sensitive = true
}

output "read_app_secret_key" {
  value     = scaleway_iam_api_key.read_key.secret_key
  sensitive = true
}
