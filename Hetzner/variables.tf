variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Prefix for all resources"
  type        = string
  default     = "k8s-ha"
}

variable "location" {
  description = "Hetzner location"
  type        = string
  default     = "fsn1"
}

variable "control_plane_count" {
  description = "Number of control plane nodes"
  type        = number
  default     = 3
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "control_plane_type" {
  description = "Hetzner server type for control plane"
  type        = string
  default     = "cpx21"
}

variable "worker_type" {
  description = "Hetzner server type for workers"
  type        = string
  default     = "cpx31"
}

variable "image" {
  description = "Hetzner image name (Ubuntu 24.04 default)"
  type        = string
  default     = "ubuntu-24.04"
}

variable "ssh_public_key_path" {
  description = "Path to public SSH key"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to private SSH key"
  type        = string
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "root"
}

variable "kubernetes_version_series" {
  description = "Kubernetes apt repo series (e.g., v1.30, v1.29)"
  type        = string
  default     = "v1.30"
}

variable "pod_cidr" {
  description = "Pod CIDR"
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  description = "Service CIDR"
  type        = string
  default     = "10.96.0.0/12"
}

variable "longhorn_version" {
  description = "Longhorn Helm chart version (optional)"
  type        = string
  default     = ""
}

variable "lb_type" {
  description = "Hetzner load balancer type"
  type        = string
  default     = "lb11"
}

variable "enable_public_ssh" {
  description = "Allow SSH from the public internet"
  type        = bool
  default     = true
}
