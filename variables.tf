variable "project_id" {
  description = "Scaleway Project ID ciblé (obligatoire)"
  type        = string
  default = "" # A Renseigner

  # vous pouvez toujours faire:
  # export TF_VAR_project_id=$(scw config get default-project-id)
  # ou `terraform apply -var "project_id=$SCW_PROJECT_ID"`
}

variable "region" {
  description = "Région Object Storage (fr-par, nl-ams, pl-war)"
  type        = string
  default     = "fr-par"
}

variable "bucket_name" {
  type    = string
  default = "test-scw-sa-fgz"
}

variable "write_allowed_ips" {
  description = "IPs/CIDRs autorisées en lecture – vide = pas de filtre"
  type        = list(string)
  default     = []
}

variable "read_allowed_ips" {
  description = "IPs/CIDRs autorisées en lecture – vide = pas de filtre"
  type        = list(string)
  default     = []
}

variable "customer_encryption_key" {
  description = "Clé AES-256 base64 pour SSE-C (optionnel)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "read_owner_id" {
  type    = string
  default = "db7047ad-0219-4880-a4ee-e790b75fb9d5"
}
