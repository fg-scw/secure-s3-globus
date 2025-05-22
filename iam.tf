# iam.tf — applications IAM + policies « least-privilege »

resource "scaleway_iam_application" "write_app" {
  name        = "globus-write-${var.bucket_name}"
  description = "Globus Compute – write access"
}

resource "scaleway_iam_application" "read_app" {
  name        = "globus-read-${var.bucket_name}"
  description = "Globus Compute – read access"
}

# --- WRITE ---

resource "scaleway_iam_policy" "write_policy" {
  name           = "object-storage-write-${var.bucket_name}"
  application_id = scaleway_iam_application.write_app.id

  rule {
    project_ids          = [var.project_id]
    permission_set_names = ["ObjectStorageFullAccess"] # nouvelle clé :contentReference[oaicite:2]{index=2}
  }
}

resource "scaleway_iam_api_key" "write_key" {
  application_id = scaleway_iam_application.write_app.id
  description    = "API key – write"
}

# --- READ ---

resource "scaleway_iam_policy" "read_policy" {
  name           = "object-storage-read-${var.bucket_name}"
  application_id = scaleway_iam_application.read_app.id

  rule {
    project_ids          = [var.project_id]
    permission_set_names = ["ObjectStorageFullAccess"]
    #permission_set_names = ["ObjectStorageReadOnly"] # nouvelle clé :contentReference[oaicite:3]{index=3}
  }
}

resource "scaleway_iam_api_key" "read_key" {
  application_id = scaleway_iam_application.read_app.id
  description    = "API key – read"
}
