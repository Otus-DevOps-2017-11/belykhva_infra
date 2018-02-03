output "external_app_ips" {
  value                 = "${google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "instance_list" {
  value                 = ["${google_compute_instance.app.*.self_link}",]
}

output "app_port" {
  value                 = ["${var.app_port}"]
}
