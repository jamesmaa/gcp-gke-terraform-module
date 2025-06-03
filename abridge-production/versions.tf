terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}


# REPLACE ME with your own backend configuration
# terraform {
#   backend "gcs" {
#     bucket = "jmaa-abridge-staging-demo"
#     prefix = "terraform/state"
#   }
# }
