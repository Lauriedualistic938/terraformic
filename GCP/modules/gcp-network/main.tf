resource "google_compute_network" "this" {
  name                    = "${var.name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name          = "${var.name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.this.id
}

resource "google_compute_firewall" "k8s_public" {
  name    = "${var.name}-fw-public"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["6443", "30000-32767"]
  }

  dynamic "allow" {
    for_each = var.enable_public_ssh ? [1] : []
    content {
      protocol = "tcp"
      ports    = ["22"]
    }
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.network_tag]
}

resource "google_compute_firewall" "k8s_internal" {
  name    = "${var.name}-fw-internal"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["10250", "2379-2380"]
  }

  allow {
    protocol = "udp"
    ports    = ["8472"]
  }

  source_ranges = [var.subnet_cidr]
  target_tags   = [var.network_tag]
}
