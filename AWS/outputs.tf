output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca" {
  value = module.eks.cluster_ca
}

output "node_group_names" {
  value = module.eks.node_group_names
}

output "efs_id" {
  value = module.eks.efs_id
}
