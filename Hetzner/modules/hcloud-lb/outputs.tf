output "public_ip" {
  value = hcloud_load_balancer.this.ipv4
}

output "private_ip" {
  value = hcloud_load_balancer_network.this.ip
}

output "id" {
  value = hcloud_load_balancer.this.id
}
