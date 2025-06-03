locals {
  apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

resource "google_project_service" "api" {
  for_each = toset(local.apis)
  service  = each.key

  project            = data.google_client_config.default.project
  disable_on_destroy = false
}