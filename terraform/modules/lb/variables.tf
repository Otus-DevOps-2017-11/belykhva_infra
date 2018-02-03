variable "lb_port" {
  default               = "80"
}

variable "app_port" {
}

variable "zone" {
}

variable "ext_app_ips" {
  type                  = "list"
}

variable "infra_prefix" {
  description           = "Environment prefix"
  type                  = "string"
}

