variable public_key_path {
  description           = "Path to the public key used for ssh access"
}

variable private_key_path {
  description           = "Path to the public key used for ssh access"
}

variable zone {
  description           = "Availability Zone"
  default               = "europe-west1-b"
}

variable app_disk_image {
  description           = "Disk image"
  default               = "reddit-app"
}

variable "app_port" {
  description           = "Application port"
}

variable "vm_count" {
  description           = "APP VMs count"
}

variable "mongodb_port" {
  description           = "APP VMs count"
}

variable "internal_db_ip" {
  description           = "External database IP address"
  type                  = "string"
}

variable "infra_prefix" {
  description           = "Environment prefix"
  type                  = "string"
}

variable "app_machine_type" {
  description           = "APP VMs intance type"
  type                  = "string"
  default               = "g1-small"
}
