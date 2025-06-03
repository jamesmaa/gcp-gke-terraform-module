variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "The GCP region where the gke cluster will be created"
  type        = string
  default     = "us-east1"
}
