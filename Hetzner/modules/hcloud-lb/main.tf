resource "hcloud_load_balancer" "this" {
  name               = var.name
  load_balancer_type = var.lb_type
  location           = var.location
}

resource "hcloud_load_balancer_network" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  network_id       = var.network_id
  ip               = var.network_ip
}

resource "hcloud_load_balancer_service" "kube_api" {
  load_balancer_id = hcloud_load_balancer.this.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_target" "control_plane" {
  for_each         = toset(var.server_ids)
  type             = "server"
  load_balancer_id = hcloud_load_balancer.this.id
  server_id        = each.value
  use_private_ip   = true
}
