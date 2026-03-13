output "network" {
  value = google_compute_network.this.name
}

output "subnetwork" {
  value = google_compute_subnetwork.this.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.this.self_link
}

output "subnet_cidr" {
  value = google_compute_subnetwork.this.ip_cidr_range
}
