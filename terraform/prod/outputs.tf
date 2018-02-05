output "external_app_ips" {
  value                 = "${module.app.external_app_ips}"
}

output "external_db_ip" {
  value                 = "${module.db.external_db_ip}"
}

output "external_ip_load_balancer" {
  value                 = "${module.lb.external_ip_load_balancer}"
}
