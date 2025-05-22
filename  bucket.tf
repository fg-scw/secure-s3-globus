resource "scaleway_object_bucket" "bucket" {
  name   = var.bucket_name
  region = var.region

  versioning { enabled = true }
  tags = { key = "managed-by-tf", key = "new" }

  lifecycle_rule {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 30
  }
}

resource "scaleway_object_bucket_acl" "main" {
  bucket = scaleway_object_bucket.bucket.id
  acl    = "private"
}

resource "scaleway_object_bucket_policy" "policy" {
  bucket = scaleway_object_bucket.bucket.name
  policy = local.bucket_policy

  # garantit que la policy est posée après la création du bucket
  depends_on = [scaleway_object_bucket.bucket]
}

