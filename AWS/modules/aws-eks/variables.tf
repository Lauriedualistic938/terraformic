variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_version" {
  type = string
}

variable "node_instance_type" {
  type = string
}

variable "node_per_az" {
  type = number
}

variable "key_name" {
  type = string
}

variable "enable_public_ssh" {
  type = bool
}

variable "vpc_cidr" {
  type = string
}
