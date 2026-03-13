variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "subnet_self_link" {
  type = string
}

variable "network" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "node_machine_type" {
  type = string
}

variable "node_per_zone" {
  type = number
}
