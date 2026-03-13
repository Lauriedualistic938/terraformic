output "ids" {
  value = hcloud_server.this[*].id
}

output "ipv4" {
  value = hcloud_server.this[*].ipv4_address
}

output "private_ipv4" {
  value = [for s in hcloud_server.this : one(s.network).ip]
}

output "names" {
  value = hcloud_server.this[*].name
}
