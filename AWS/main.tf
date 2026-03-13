data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_key_pair" "this" {
  key_name   = var.ssh_key_name
  public_key = file(var.ssh_public_key_path)
}

module "network" {
  source              = "./modules/aws-network"
  name                = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnet_cidrs))
}

module "eks" {
  source             = "./modules/aws-eks"
  name               = var.project_name
  vpc_id             = module.network.vpc_id
  vpc_cidr           = module.network.vpc_cidr
  subnet_ids         = module.network.public_subnet_ids
  cluster_version    = var.cluster_version
  node_instance_type = var.node_instance_type
  node_per_az         = var.node_per_az
  key_name           = aws_key_pair.this.key_name
  enable_public_ssh  = var.enable_public_ssh
}

data "aws_eks_cluster" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

resource "kubernetes_storage_class" "efs" {
  depends_on = [module.eks]

  metadata {
    name = "efs-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  provisioner          = "efs.csi.aws.com"
  reclaim_policy       = "Retain"
  volume_binding_mode  = "Immediate"

  parameters = {
    fileSystemId = module.eks.efs_id
  }
}
