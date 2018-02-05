########### ПРАВИЛА ДЛЯ ФОРВАРДИНГА ТРАФИКА ########
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "${var.infra_prefix}-forwarding-rule"
  port_range            = "${var.lb_port}"
  ip_protocol           = "TCP"
  target                = "${google_compute_target_http_proxy.default.self_link}"
}
#--------------------------------------------------#

################## HTTP PROXY ######################
resource "google_compute_target_http_proxy" "default" {
  name                  = "${var.infra_prefix}-proxy"
  description           = "a description"
  url_map               = "${google_compute_url_map.default.self_link}"
}
#--------------------------------------------------#

################### BACKEND ########################
resource "google_compute_backend_service" "default" {
  name                  = "${var.infra_prefix}-backend"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 10

  backend {
    group               = "${google_compute_instance_group.webservers.self_link}"
  }

  health_checks         = ["${google_compute_http_health_check.default.self_link}"]
}
#---------------------------------------------------#

################### URL MAP #########################
resource "google_compute_url_map" "default" {
  name                  = "${var.infra_prefix}-url-map"
  description           = "a description"
  default_service       = "${google_compute_backend_service.default.self_link}"
}
#---------------------------------------------------#

############### HEALTH CHECKER ######################
resource "google_compute_http_health_check" "default" {
  name                  = "${var.infra_prefix}-internal-service-health-check"
  
  timeout_sec           = 1
  check_interval_sec    = 1
  port                  = "${var.app_port}"
}
#---------------------------------------------------#

############### ГРУППА ИНСТАНСОВ ####################
resource "google_compute_instance_group" "webservers" {
  name                  = "${var.infra_prefix}-webservers"
  description           = "Terraform test instance group"

  instances             = ["${var.ext_app_ips}",]

  named_port {
    name                = "http"
    port                = "${var.app_port}"
  }

 zone                   = "${var.zone}"
}
#---------------------------------------------------#
