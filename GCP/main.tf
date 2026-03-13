data "google_client_config" "this" {}

module "network" {
  source            = "./modules/gcp-network"
  name              = var.project_name
  region            = var.region
  subnet_cidr        = var.subnet_cidr
  enable_public_ssh = var.enable_public_ssh
  network_tag       = "${var.project_name}-gke"
}

module "gke" {
  source            = "./modules/gcp-gke"
  name              = var.project_name
  region            = var.region
  zones             = var.zones
  network           = module.network.network
  subnet_self_link  = module.network.subnet_self_link
  cluster_version   = var.cluster_version
  node_machine_type = var.node_machine_type
  node_per_zone     = var.node_per_zone
}

module "filestore" {
  source       = "./modules/gcp-filestore"
  name         = var.project_name
  region       = var.region
  subnet_cidr  = var.subnet_cidr
  network      = module.network.network
  tier         = var.filestore_tier
  capacity_gb  = var.filestore_capacity_gb
}

resource "kubernetes_storage_class" "filestore" {
  metadata {
    name = "filestore-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  provisioner = "filestore.csi.storage.gke.io"

  parameters = {
    instance = module.filestore.instance_name
  }
}
