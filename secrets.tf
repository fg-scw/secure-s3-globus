# Clé SSE-C
resource "scaleway_secret" "sse_c" {
  name        = "sse-c-${var.bucket_name}"
  description = "SSE-C key for bucket ${var.bucket_name}"
}

resource "scaleway_secret_version" "sse_c_v1" {
  secret_id = scaleway_secret.sse_c.id
  data      = local.sse_c_key
}

# Credentials – write
resource "scaleway_secret" "write_creds" {
  name        = "write-creds-${var.bucket_name}"
  description = "API credentials – write"
}

resource "scaleway_secret_version" "write_creds_v1" {
  secret_id = scaleway_secret.write_creds.id
  data = jsonencode({
    access_key = scaleway_iam_api_key.write_key.access_key
    secret_key = scaleway_iam_api_key.write_key.secret_key
    region     = var.region
    bucket     = var.bucket_name
    sse_c_key  = local.sse_c_key
  })
  depends_on = [scaleway_iam_api_key.write_key]
}

# Credentials – read
resource "scaleway_secret" "read_creds" {
  name        = "read-creds-${var.bucket_name}"
  description = "API credentials – read"
}

resource "scaleway_secret_version" "read_creds_v1" {
  secret_id = scaleway_secret.read_creds.id
  data = jsonencode({
    access_key = scaleway_iam_api_key.read_key.access_key
    secret_key = scaleway_iam_api_key.read_key.secret_key
    region     = var.region
    bucket     = var.bucket_name
    sse_c_key  = local.sse_c_key
  })
  depends_on = [scaleway_iam_api_key.read_key]
}
