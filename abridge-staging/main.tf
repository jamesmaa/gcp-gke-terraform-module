provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc_with_gke" {
  source     = "./.."
  project_id = var.project_id

  # Networking variables
  vpc_name = "abridge-staging-vpc"
  region   = var.region

  # GKE variables
  gke_subnet_node_ip_cidr_range     = "10.0.0.0/14"
  gke_subnet_pods_ip_cidr_range     = "10.4.0.0/14"
  gke_subnet_services_ip_cidr_range = "10.8.0.0/18"
  gke_cluster_name                  = "abridge-staging-gke-cluster"
  deletion_protection               = false
  node_pools = [
    {
      name                 = "default-pool"
      machine_type         = "e2-small"
      total_min_node_count = 1
      total_max_node_count = 3
      preemptible          = false
    }
  ]
}
