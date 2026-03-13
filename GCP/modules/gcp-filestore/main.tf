resource "google_filestore_instance" "this" {
  name     = "${var.name}-fs"
  location = var.region
  tier     = var.tier

  file_shares {
    capacity_gb = var.capacity_gb
    name        = "vol1"
  }

  networks {
    network           = var.network
    modes             = ["MODE_IPV4"]
    reserved_ip_range = var.subnet_cidr
  }
}
