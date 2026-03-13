provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zones[0]
  credentials = var.credentials_file != "" ? file(var.credentials_file) : null
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  cluster_ca_certificate = base64decode(module.gke.cluster_ca)
  token                  = data.google_client_config.this.access_token
}
