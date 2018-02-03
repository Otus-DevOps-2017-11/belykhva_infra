output "internal_db_ip" {
  value                 = "${google_compute_instance.db.*.network_interface.0.address}"
}

output "external_db_ip" {
  value                 = "${google_compute_instance.db.*.network_interface.0.access_config.0.assigned_nat_ip}"
}
