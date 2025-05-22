####################
#  Clé SSE-C
####################
resource "random_password" "encryption_key" {
    count   = var.customer_encryption_key == "" ? 1 : 0
    length  = 32
    special = false
}

locals {
    sse_c_key = var.customer_encryption_key != "" ? var.customer_encryption_key : random_password.encryption_key[0].result

##############################
#  Conditions Bucket Policy
##############################
    write_condition_block = length(var.write_allowed_ips) > 0 ? {
        Condition = {
        IpAddress = { "aws:SourceIp" = var.write_allowed_ips }
        }
    } : {}

    read_condition_block = length(var.read_allowed_ips) > 0 ? {
        Condition = {
        IpAddress = { "aws:SourceIp" = var.read_allowed_ips }
        }
    } : {}

#######################################
#  Bucket-policy « least-privilege »
#######################################

    bucket_policy = jsonencode({
        Version = "2023-04-17",
        Id      = "MyBucketPolicy"

    Statement = [
        # ----- WRITE ---------------------------------------------------------
        merge({
            Sid    = "AllowWrite"
            Effect = "Allow"
            Principal = {
            SCW = ["application_id:${scaleway_iam_application.write_app.id}"]
            }
            Action = [
            "s3:PutObject",
            "s3:ListBucket",
            "s3:GetBucketLocation"
            ]
            Resource = [
            var.bucket_name,
            "${var.bucket_name}/*"
            ]
        }, local.write_condition_block),

        # ----- READ ----------------------------------------------------------
        merge({
            Sid    = "AllowRead"
            Effect = "Allow"
            Principal = {
            SCW = ["application_id:${scaleway_iam_application.read_app.id}"]
            }
            Action = [
            "s3:GetObject",
            "s3:ListBucket",
            "s3:GetObjectVersion",
            "s3:GetBucketVersioning",
            "s3:ListBucketVersions",
            "s3:GetBucketLocation"
            ]
            Resource = [
            var.bucket_name,
            "${var.bucket_name}/*"
            ]
        }, local.read_condition_block),

        # ----- ADMIN ----------------------------------------------------------
        merge({
            Sid    = "Scaleway secure statement"
            Action = "*"
            Effect = "Allow"
            Resource = [
            var.bucket_name,
            "${var.bucket_name}/*"
            ]
            Principal = {
            SCW = ["user_id:${var.read_owner_id}"]
            }
        })
        ]
    })
}
