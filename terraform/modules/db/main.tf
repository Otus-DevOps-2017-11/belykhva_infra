resource "google_compute_instance" "db" {
  name                  = "${var.infra_prefix}-reddit-db"
  machine_type          = "${var.db_machine_type}"
  zone                  = "${var.zone}"

  tags                  = ["${var.infra_prefix}-reddit-db"]

  metadata {
    sshKeys             = "appuser:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image             = "${var.db_disk_image}"
    }
  }

  network_interface {
    network             = "default"
    access_config {}
  }

  connection {
    type                = "ssh"
    user                = "appuser"
    agent               = false
    private_key         = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    content             = "${data.template_file.mongo_conf.rendered}"
    destination         = "/tmp/mongod.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/mongod.conf /etc/mongod.conf",
      "sudo systemctl restart mongod",
    ]
  }
}

data "template_file" "mongo_conf" {
    template            = "${file("${path.module}/files/mongod.conf.tpl")}"

    vars {
      mongodb_bind      = "${var.mongodb_bind}"
      mongodb_port      = "${var.mongodb_port}"
    }
}
