# locals.tf — génération optionnelle de la clé SSE-C et construction
# d'une bucket-policy strictement « least-privilege » + filtrage IP.

resource "random_password" "encryption_key" {
    count   = var.customer_encryption_key == "" ? 1 : 0
    length  = 32
    special = false
}

locals {
    # 1) clé de chiffrement : soit l'utilisateur l’a fournie (voir tfvars), soit on utilise celle générée.
    sse_c_key = var.customer_encryption_key != "" ? var.customer_encryption_key : random_password.encryption_key[0].result

    # 2) bucket-policy
    bucket_policy = jsonencode({
        Id = "Restrict-access"
        Version = "2023-04-17"
        Statement = [

        # — Write depuis l’application IAM + IPs allowed —
        {
            Sid    = "AllowWriteFromWriteApp"
            Effect = "Allow"
            Principal = {
            SCW = ["application_id:${scaleway_iam_application.write_app.id}"]
            }
            Action   = [
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:AbortMultipartUpload",
                "s3:PutObjectVersionTagging",
                "s3:PutObjectTagging",
                "s3:PutObjectRetention",
                "s3:PutObjectLegalHold"
                ]
            Resource = [
                var.bucket_name,
                format("%s/*", var.bucket_name)
                ]
            Condition = {
            IpAddress = { "aws:SourceIp" = var.write_allowed_ips }
            }
        },

        # — READ depuis l’application IAM + IPs allowed —
        {
            Sid    = "AllowReadFromReadApp"
            Effect = "Allow"
            Principal = {
            SCW = ["application_id:${scaleway_iam_application.read_app.id}"]
            }
            Action = [
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:GetObject",
                "s3:GetObjectVersion"
                ]
            #Resource = [var.bucket_name]
            Resource = [
            var.bucket_name,
            format("%s/*", var.bucket_name)
            ]
            Condition = {
            IpAddress = { "aws:SourceIp" = var.read_allowed_ips }
            }
        },

        # — SECURE L'accès au propriétaire de l'orga pour éviter de se retrouver bloqué —
        {
        Sid = "Scaleway secure statement"
        Action = "*"
        Effect = "Allow"
        Resource = [
            "test-scw-sa-fgz",
            "test-scw-sa-fgz/*"
        ]
        Principal = {
            SCW = ["user_id:${var.read_owner_id}"]
        }
        }
        ]
    })
}
