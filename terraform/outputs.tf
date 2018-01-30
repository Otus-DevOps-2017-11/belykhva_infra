output "external_ip_appserver_1" {
  value = "${google_compute_instance.app.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "external_ip_appserver_2" {
  value = "${google_compute_instance.app2.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "external_ip_load_balancer" {
  value = "${google_compute_global_forwarding_rule.default.ip_address}"
}

