variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Prefix for all resources"
  type        = string
  default     = "k8s-eks"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (3 subnets in distinct AZs)"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.large"
}

variable "node_per_az" {
  description = "Worker nodes per AZ (one node group per subnet)"
  type        = number
  default     = 1
}

variable "ssh_public_key_path" {
  description = "Path to public SSH key"
  type        = string
}

variable "ssh_key_name" {
  description = "Name for the AWS key pair"
  type        = string
  default     = "k8s-eks-key"
}

variable "enable_public_ssh" {
  description = "Allow SSH to worker nodes from the public internet"
  type        = bool
  default     = true
}

variable "enable_efs" {
  description = "Provision EFS and install the EFS CSI driver"
  type        = bool
  default     = true
}
