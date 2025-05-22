variable "project_id" {
    type = string
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
    #default = ["51.159.159.159/32"]
}

variable "read_allowed_ips" {
    type    = list(string)
    default = ["0.0.0.0"]
    #default = ["91.56.56.56/32", "85.25.36.34/32"]
}

variable "customer_encryption_key" {
    description = "Clé AES-256 base64 pour SSE-C (optionnel)"
    type        = string
    sensitive   = true
    default     = ""
}

variable "read_owner_id" {
    type    = string
    default = "db7047ad-0219-4880-a4ee-e790b75fb9d5" #Mettre son user_id ayant les droits admin
}
