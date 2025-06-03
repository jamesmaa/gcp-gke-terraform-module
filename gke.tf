resource "google_container_cluster" "gke_cluster" {
  name     = var.gke_cluster_name
  location = var.region

  # We can't use the default node pool, so we set this to true
  # to remove it and create our own node pools.
  remove_default_node_pool = true
  initial_node_count       = 1

  network         = google_compute_network.vpc.self_link
  subnetwork      = google_compute_subnetwork.gke_subnet.self_link
  networking_mode = "VPC_NATIVE"

  deletion_protection = var.deletion_protection

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.gke_subnet.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.gke_subnet.secondary_ip_range[1].range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "192.168.0.0/28"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "node_pools" {
  for_each = { for pool in var.node_pools : pool.name => pool }

  name     = each.value.name
  location = var.region
  cluster  = google_container_cluster.gke_cluster.name

  autoscaling {
    total_min_node_count = each.value.total_min_node_count
    total_max_node_count = each.value.total_max_node_count
  }

  node_config {
    machine_type    = each.value.machine_type
    service_account = google_service_account.gke_sa.email

    preemptible = each.value.preemptible

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]

    labels = merge(
      each.value.labels,
      {
        "k8s-node-pool" = each.value.name
      }
    )
  }
}
