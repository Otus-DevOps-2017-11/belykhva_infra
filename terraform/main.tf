############ ОПРЕДЕЛЕНИЕ ПРОВАЙДЕРА ##############
provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}
#------------------------------------------------#


#resource "google_compute_project_metadata_item" "ssh_public_key" {
#  key = "sshKeys"
#  value = "appuser:${file(pathexpand("~/.ssh/appuser.pub"))}"
#}

########## ДОБАВЛЕНИЕ КЛЮЧЕЙ В ПРОЕКТ ############
data "template_file" "ssh_string_generator" {
  count = "${length(var.keys)}"
  template = "$${user}:$${key}"
  vars {
    user  = "${element(keys(var.keys),count.index)}"
    key   = "${file(pathexpand(var.keys["${element(keys(var.keys),count.index)}"]))}"
  }
}

resource "google_compute_project_metadata_item" "double_public_keys" {
  key = "ssh-keys"
  value = "${join("", "${data.template_file.ssh_string_generator.*.rendered}")}"
}
#------------------------------------------------#

################## ПЕРВЫЙ ИНСТАНС ################
resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"

  tags = ["reddit-app"]

  metadata {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}
#------------------------------------------------#

################## ВТОРОЙ ИНСТАНС ################
resource "google_compute_instance" "app2" {
  name         = "reddit-app2"
  machine_type = "g1-small"
  zone         = "${var.zone}"

  tags = ["reddit-app"]

  metadata {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}
#--------------------------------------------------#

########### ПРАВИЛА ДЛЯ ФОРВАРДИНГА ТРАФИКА ########
resource "google_compute_global_forwarding_rule" "default" {
  name       = "default-rule"
  port_range = "80"
  ip_protocol = "TCP"
  target     = "${google_compute_target_http_proxy.default.self_link}"
}
#--------------------------------------------------#

################## HTTP PROXY ######################
resource "google_compute_target_http_proxy" "default" {
  name        = "test-proxy"
  description = "a description"
  url_map     = "${google_compute_url_map.default.self_link}"
}
#--------------------------------------------------#

################### BACKEND ########################
resource "google_compute_backend_service" "default" {
  name        = "default-backend"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = "${google_compute_instance_group.webservers.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.default.self_link}"]
}
#---------------------------------------------------#

################### URL MAP ########################
resource "google_compute_url_map" "default" {
  name            = "url-map"
  description     = "a description"
  default_service = "${google_compute_backend_service.default.self_link}"
}
#--------------------------------------------------#

############### HEALTH CHECKER ######################
resource "google_compute_http_health_check" "default" {
  name = "internal-service-health-check"
  
  timeout_sec        = 1
  check_interval_sec = 1
  port = "9292"
}
#---------------------------------------------------#

############### ГРУППА ИНСТАНСОВ ####################
resource "google_compute_instance_group" "webservers" {
  name        = "terraform-webservers"
  description = "Terraform test instance group"

  instances = [
    "${google_compute_instance.app.self_link}",
    "${google_compute_instance.app2.self_link}",
  ]

  named_port {
    name = "http"
    port = "9292"
  }

 zone = "${var.zone}"
}
#---------------------------------------------------#


############### FIREWALL RULES #####################
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}
#--------------------------------------------------#