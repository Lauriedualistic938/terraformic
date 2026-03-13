resource "google_container_cluster" "this" {
  name     = var.name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnet_self_link

  min_master_version = var.cluster_version
}

resource "google_container_node_pool" "this" {
  for_each = toset(var.zones)

  name       = "${var.name}-np-${replace(each.value, "-", "") }"
  cluster    = google_container_cluster.this.name
  location   = var.region
  node_count = var.node_per_zone

  node_config {
    machine_type = var.node_machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_locations = [each.value]
}
