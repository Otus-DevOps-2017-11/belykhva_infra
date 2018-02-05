resource "google_compute_firewall" "firewall_ssh" {
  name                  = "${var.infra_prefix}-allow-ssh"
  network               = "default"

  allow {
    protocol            = "tcp"
    ports               = ["22"]
  }
  source_ranges         = ["${var.ssh_sources_ranges}"]
}

resource "google_compute_firewall" "firewall_mongo" {
  name                  = "${var.infra_prefix}-allow-mongo"
  network               = "default"

  allow {
    protocol            = "tcp"
    ports               = ["27017"]
  }

  source_tags           = ["${var.infra_prefix}-reddit-app"]
  target_tags           = ["${var.infra_prefix}-reddit-db"]
}

resource "google_compute_firewall" "firewall_puma" {
  name                  = "${var.infra_prefix}-allow-app"
  network               = "default"

  allow {
    protocol            = "tcp"
    ports               = ["${var.app_port}"]
  }

  source_ranges         = ["0.0.0.0/0"]
  target_tags           = ["${var.infra_prefix}-reddit-app"]
}
