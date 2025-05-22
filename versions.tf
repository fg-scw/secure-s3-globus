terraform {
    required_version = ">= 1.8.0"

    required_providers {
        scaleway = {
        source  = "scaleway/scaleway"
        version = ">= 2.54.0"
        }
        random = {
        source  = "hashicorp/random"
        version = ">= 3.6.0"
        }
    }
}

provider "scaleway" {
    project_id = var.project_id
    region     = var.region
    # Les variables d'environnement SCW_ACCESS_KEY / SCW_SECRET_KEY sont lues automatiquement
}
