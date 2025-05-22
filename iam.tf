# iam.tf — applications IAM + policies « least-privilege »

resource "scaleway_iam_application" "write_app" {
  name        = "globus-write-${var.bucket_name}"
  description = "Globus Compute – write access"
}

resource "scaleway_iam_application" "read_app" {
  name        = "globus-read-${var.bucket_name}"
  description = "Globus Compute – read access"
}

# -------- POLICIES --------

resource "scaleway_iam_policy" "write_policy" {
  name           = "object-storage-write-${var.bucket_name}"
  application_id = scaleway_iam_application.write_app.id

  rule {
    project_ids          = [var.project_id]
    permission_set_names = ["ObjectStorageFullAccess"]
  }
}

resource "scaleway_iam_policy" "read_policy" {
  name           = "object-storage-read-${var.bucket_name}"
  application_id = scaleway_iam_application.read_app.id

  rule {
    project_ids          = [var.project_id]
    permission_set_names = ["ObjectStorageReadOnly"]
  }
}


# -------- API KEYS --------

resource "scaleway_iam_api_key" "write_key" {
  application_id     = scaleway_iam_application.write_app.id
  description        = "API key – write"
  default_project_id = var.project_id
}

resource "scaleway_iam_api_key" "read_key" {
  application_id     = scaleway_iam_application.read_app.id
  description        = "API key – read"
  default_project_id = var.project_id
}
