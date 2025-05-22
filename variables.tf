variable "project_id" {
    type = string
    default = "" # A renseigner

    # vous pouvez toujours faire:
    # export TF_VAR_project_id=$(scw config get default-project-id)
    # ou `terraform apply -var "project_id=$SCW_PROJECT_ID"`
}

variable "region" {
    type    = string
    default = "fr-par"
}

variable "bucket_name" {
    type    = string
    default = "test-scw-sa-fgz"
}

variable "write_allowed_ips" {
    type    = list(string)
    default = ["0.0.0.0"]
}

variable "read_allowed_ips" {
    type    = list(string)
    default = ["0.0.0.0"]
}

variable "customer_encryption_key" {
    description = "Clé AES-256 base64 pour SSE-C (optionnel)"
    type        = string
    sensitive   = true
    default     = ""
}

variable "read_owner_id" {
    type    = string
    default = "" # A renseigner avec un user/app_id ayant les droits admin si besoin
}
