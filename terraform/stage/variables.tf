variable project {
  description           = "Project ID"
}

variable region {
  description           = "Region"
  default               = "europe-west1"
}

variable public_key_path {
  description           = "Path to the public key used for ssh access"
}

variable disk_image {
  description           = "Disk image"
}

variable private_key_path {
  description           = "Private key path"
}

variable zone {
  description           = "Availability Zone"
  default               = "europe-west1-b"
}

variable "keys" { 
  description           = "Path to publuc keys used for project"
  default               = {} 
}

variable "lb_port" {
  description           = "Load Balancer port"
  default               = "80"
}

variable db_disk_image {
  description           = "Disk image for DB instance" 
  default               = "reddit-db"
}

variable app_disk_image {
  description           = "Disk image for APP instance"
  default               = "reddit-app"
}

variable "app_port" {
  description           = "Application port"
  default               = "9292"
}

variable "vm_count" {
  description           = "APP VMs count"
  default               = "2"
}

variable "ssh_sources_ranges" {
  description           = "SSH sources"
  type                  = "list"
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

variable "db_machine_type" {
  description           = "DB VMs intance type"
  type                  = "string"
  default               = "g1-small"
}

variable "mongodb_bind" {
  type = "string"
  description = "MongoDB binded IP"
}

variable "mongodb_port" {
  type = "string"
  description = "MongoDB binded port"
}
