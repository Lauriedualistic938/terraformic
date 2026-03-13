output "load_balancer_public_ip" {
  value = module.lb.public_ip
}

output "load_balancer_private_ip" {
  value = module.lb.private_ip
}

output "control_plane_public_ips" {
  value = module.control_plane.ipv4
}

output "worker_public_ips" {
  value = module.workers.ipv4
}

output "kubeconfig_path" {
  value = "${path.module}/kubeconfig"
}
