variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created"
  type        = string
  default     = "us-east1"
}

## Networking Variables

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "gke-vpc"
}

variable "gke_subnet_node_ip_cidr_range" {
  description = "The CIDR range for the GKE node IPs in the subnetwork"
  type        = string
  default     = "10.0.0.0/14"
}

variable "gke_subnet_pods_ip_cidr_range" {
  description = "The CIDR range for the GKE pods IPs in the subnetwork"
  type        = string
  default     = "10.4.0.0/14"
}

variable "gke_subnet_services_ip_cidr_range" {
  description = "The CIDR range for the GKE services IPs in the subnetwork"
  type        = string
  default     = "10.8.0.0/18"
}

## GKE Variables

variable "gke_cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "gke-cluster"
}

variable "deletion_protection" {
  description = "Enable deletion protection for the GKE cluster"
  type        = bool
  default     = true
}

variable "node_pools" {
  description = "List of node pools to be created in the GKE cluster"
  type = list(object({
    name                 = string
    machine_type         = string
    total_min_node_count = number
    total_max_node_count = number
    preemptible          = optional(bool, false)
    labels               = optional(map(string), {})
  }))
  default = [
    {
      name                 = "default-pool"
      machine_type         = "e2-medium"
      total_min_node_count = 1
      total_max_node_count = 3
      preemptible          = false
    }
  ]
}
