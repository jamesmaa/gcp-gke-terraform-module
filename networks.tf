resource "google_compute_network" "vpc" {
  name         = var.vpc_name
  project      = data.google_client_config.default.project
  routing_mode = "REGIONAL"
  description  = "VPC network"

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke_subnet" {
  name          = "gke-subnet"
  ip_cidr_range = var.gke_subnet_node_ip_cidr_range
  region        = var.region
  network       = google_compute_network.vpc.id

  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = var.gke_subnet_pods_ip_cidr_range
  }

  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = var.gke_subnet_services_ip_cidr_range
  }

  private_ip_google_access = true
}
