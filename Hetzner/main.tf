locals {
  subnet_cidr = "10.0.0.0/24"
  internal_cidr = "10.0.0.0/16"
  longhorn_version_arg = var.longhorn_version != "" ? "--version ${var.longhorn_version}" : ""
}

data "local_file" "ssh_public_key" {
  filename = var.ssh_public_key_path
}

resource "hcloud_ssh_key" "this" {
  name       = "${var.project_name}-key"
  public_key = data.local_file.ssh_public_key.content
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

locals {
  control_plane_ips = module.control_plane.ipv4
  worker_ips        = module.workers.ipv4
  first_cp_ip        = local.control_plane_ips[0]
}

resource "null_resource" "kubeadm_init" {
  depends_on = [module.control_plane, module.lb]

  connection {
    host        = local.first_cp_ip
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "kubeadm init --control-plane-endpoint ${module.lb.private_ip}:6443 --apiserver-cert-extra-sans ${module.lb.private_ip},${module.lb.public_ip} --upload-certs --pod-network-cidr ${var.pod_cidr} --service-cidr ${var.service_cidr}",
      "mkdir -p /root/.kube",
      "cp /etc/kubernetes/admin.conf /root/.kube/config",
      "kubeadm init phase upload-certs --upload-certs | tail -n 1 | tr -d '\\n' > /etc/kubeadm/cert.key",
      "kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml"
    ]
  }
}

data "external" "join_commands" {
  depends_on = [null_resource.kubeadm_init]

  program = ["python3", "${path.module}/scripts/get_join_commands.py"]

  query = {
    host     = local.first_cp_ip
    user     = var.ssh_user
    key_path = var.ssh_private_key_path
  }
}

resource "null_resource" "join_control_planes" {
  depends_on = [data.external.join_commands]

  for_each = toset(slice(local.control_plane_ips, 1, length(local.control_plane_ips)))

  connection {
    host        = each.value
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      data.external.join_commands.result.control_plane
    ]
  }
}

resource "null_resource" "join_workers" {
  depends_on = [data.external.join_commands]

  for_each = toset(local.worker_ips)

  connection {
    host        = each.value
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      data.external.join_commands.result.worker
    ]
  }
}

resource "null_resource" "longhorn" {
  depends_on = [null_resource.join_workers]

  connection {
    host        = local.first_cp_ip
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash",
      "helm repo add longhorn https://charts.longhorn.io",
      "helm repo update",
      "kubectl create namespace longhorn-system || true",
      "helm install longhorn longhorn/longhorn -n longhorn-system ${local.longhorn_version_arg}",
      "kubectl -n longhorn-system rollout status deploy/longhorn-manager --timeout=10m"
    ]
  }
}

resource "null_resource" "fetch_kubeconfig" {
  depends_on = [null_resource.kubeadm_init]

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.ssh_private_key_path} ${var.ssh_user}@${local.first_cp_ip}:/etc/kubernetes/admin.conf ${path.module}/kubeconfig"
  }
}
