output "cluster_name" {
  value = module.gke.cluster_name
}

output "cluster_endpoint" {
  value = module.gke.endpoint
}

output "cluster_ca" {
  value = module.gke.cluster_ca
}

output "filestore_instance" {
  value = module.filestore.instance_name
}
