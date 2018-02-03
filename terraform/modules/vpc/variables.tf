variable "app_port" {
  type                  = "string"
  description           = "Application port"
}

variable "ssh_sources_ranges" {
  type                  = "list"
  description           = "SSH sources"
}

variable "infra_prefix" {
  description           = "Environment prefix"
  type                  = "string"
}
