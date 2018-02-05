resource "google_compute_instance" "app" {
  count                 = "${var.vm_count}"
  name                  = "${var.infra_prefix}-app-${count.index}"
  machine_type          = "${var.app_machine_type}"
  zone                  = "${var.zone}"

  tags                  = ["${var.infra_prefix}-reddit-app"]

  metadata {
    sshKeys             = "appuser:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image             = "${var.app_disk_image}"
    }
  }

  network_interface {
    network             = "default"
    access_config {
      nat_ip            = "${google_compute_address.app_ip.*.address[count.index]}"
    }
  }
  
  connection {
    type                = "ssh"
    user                = "appuser"
    agent               = false
    private_key         = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    content             = "${data.template_file.init.rendered}"
    destination         = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script              = "${path.module}/files/deploy.sh"
  }
}

data "template_file" "init" {
     template            = "${file("${path.module}/files/puma.service.tpl")}"
#    template            = "${path.module}/files/puma.service.tpl}"

    vars {
      database_ip_address     = "${var.internal_db_ip}"
      app_port                = "${var.app_port}"
      mongodb_port            = "${var.mongodb_port}"
    }
}

resource "google_compute_address" "app_ip" {
  count                 = "${var.vm_count}"
  name                  = "${var.infra_prefix}-ip-${count.index}"
}
