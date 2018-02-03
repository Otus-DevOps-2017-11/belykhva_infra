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

variable db_disk_image {
  description           = "Disk image"
  default               = "reddit-db"
}

variable "infra_prefix" {
  description           = "Environment prefix"
  type                  = "string"
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
