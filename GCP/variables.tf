variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "credentials_file" {
  description = "Path to GCP service account JSON (optional if using ADC)"
  type        = string
  default     = ""
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "zones" {
  description = "Zones for nodes (3 zones in same region)"
  type        = list(string)
  default     = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
}

variable "project_name" {
  description = "Prefix for all resources"
  type        = string
  default     = "k8s-gke"
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
  default     = "10.0.0.0/24"
}

variable "cluster_version" {
  description = "GKE Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "node_machine_type" {
  description = "Machine type for worker nodes"
  type        = string
  default     = "e2-standard-4"
}

variable "node_per_zone" {
  description = "Worker nodes per zone"
  type        = number
  default     = 1
}

variable "enable_public_ssh" {
  description = "Allow SSH to nodes from the public internet"
  type        = bool
  default     = true
}

variable "filestore_tier" {
  description = "Filestore tier (BASIC_HDD, BASIC_SSD, ENTERPRISE)"
  type        = string
  default     = "BASIC_HDD"
}

variable "filestore_capacity_gb" {
  description = "Filestore capacity (GB)"
  type        = number
  default     = 1024
}
