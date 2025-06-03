resource "google_service_account" "gke_sa" {
  account_id   = "${var.gke_cluster_name}-sa"
  display_name = "GKE Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "gke_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_metrics" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}