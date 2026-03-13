locals {
  subnet_cidr   = "10.0.0.0/24"
  internal_cidr = "10.0.0.0/16"
}

data "local_file" "ssh_public_key" {
  filename = var.ssh_public_key_path
}

resource "hcloud_ssh_key" "this" {
  name       = "${var.project_name}-key"
  public_key = data.local_file.ssh_public_key.content
}

resource "random_password" "kubeadm_token" {
  length  = 6
  special = false
  upper   = false
}

resource "random_password" "kubeadm_token_suffix" {
  length  = 16
  special = false
  upper   = false
}

resource "random_id" "certificate_key" {
  byte_length = 32
}

locals {
  kubeadm_token = "${random_password.kubeadm_token.result}.${random_password.kubeadm_token_suffix.result}"
}

module "network" {
  source       = "./modules/hcloud-network"
  name         = "${var.project_name}-net"
  ip_range     = local.internal_cidr
  subnet_range = local.subnet_cidr
}

module "control_plane" {
  source            = "./modules/hcloud-servers"
  name              = var.project_name
  role              = "cp"
  count             = var.control_plane_count
  image             = var.image
  server_type        = var.control_plane_type
  location          = var.location
  ssh_key_id         = hcloud_ssh_key.this.id
  network_id        = module.network.network_id
  subnet_cidr       = local.subnet_cidr
  ip_offset         = 10
  user_data         = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
    k8s_version_series = var.kubernetes_version_series
    role               = "cp"
    is_bootstrap        = "${count.index == 0 ? true : false}"
    lb_ip              = "${module.lb.private_ip}"
    kubeadm_token      = local.kubeadm_token
    certificate_key    = random_id.certificate_key.hex
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
    vault_root_token   = var.vault_root_token
    vault_nodeport     = var.vault_nodeport
    longhorn_version   = var.longhorn_version
  })
  enable_public_ssh = var.enable_public_ssh
  internal_cidr     = local.internal_cidr
}

module "workers" {
  source            = "./modules/hcloud-servers"
  name              = var.project_name
  role              = "worker"
  count             = var.worker_count
  image             = var.image
  server_type       = var.worker_type
  location          = var.location
  ssh_key_id         = hcloud_ssh_key.this.id
  network_id        = module.network.network_id
  subnet_cidr       = local.subnet_cidr
  ip_offset         = 100
  user_data         = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
    k8s_version_series = var.kubernetes_version_series
    role               = "worker"
    is_bootstrap        = "false"
    lb_ip              = "${module.lb.private_ip}"
    kubeadm_token      = local.kubeadm_token
    certificate_key    = random_id.certificate_key.hex
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
    vault_root_token   = var.vault_root_token
    vault_nodeport     = var.vault_nodeport
    longhorn_version   = var.longhorn_version
  })
  enable_public_ssh = var.enable_public_ssh
  internal_cidr     = local.internal_cidr
}

module "lb" {
  source      = "./modules/hcloud-lb"
  name        = "${var.project_name}-api"
  location    = var.location
  lb_type     = var.lb_type
  network_id  = module.network.network_id
  server_ids  = module.control_plane.ids
}
