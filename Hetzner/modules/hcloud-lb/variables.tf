variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "lb_type" {
  type = string
}

variable "network_id" {
  type = string
}

variable "network_ip" {
  type    = string
  default = "10.0.0.5"
}

variable "server_ids" {
  type = list(string)
}
