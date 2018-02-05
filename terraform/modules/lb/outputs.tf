output "external_ip_load_balancer" {
  value                 = "${google_compute_global_forwarding_rule.default.ip_address}"
}
