provider "google" {
  version               = "1.4.0"
  project               = "${var.project}"
  region                = "${var.region}"
}

data "template_file" "ssh_string_generator" {
  count                 = "${length(var.keys)}"
  template              = "$${user}:$${key}"
  vars {
    user                = "${element(keys(var.keys),count.index)}"
    key                 = "${file(pathexpand(var.keys["${element(keys(var.keys),count.index)}"]))}"
  }
}

resource "google_compute_project_metadata_item" "double_public_keys" {
  key                   = "ssh-keys"
  value                 = "${join("", "${data.template_file.ssh_string_generator.*.rendered}")}"
}

module "app" {
  source                = "../modules/app"
  infra_prefix          = "${var.infra_prefix}"
  app_machine_type      = "${var.app_machine_type}"
  vm_count              = "${var.vm_count}"
  public_key_path       = "${var.public_key_path}"
  private_key_path      = "${var.private_key_path}"
  zone                  = "${var.zone}"
  app_disk_image        = "${var.app_disk_image}"
  app_port              = "${var.app_port}"
  mongodb_port          = "${var.mongodb_port}"
  internal_db_ip        = "${module.db.internal_db_ip[0]}"
}

module "db" {
  source                = "../modules/db"
  infra_prefix          = "${var.infra_prefix}"
  db_machine_type       = "${var.db_machine_type}"
  public_key_path       = "${var.public_key_path}"
  private_key_path      = "${var.private_key_path}"
  zone                  = "${var.zone}"
  db_disk_image         = "${var.db_disk_image}"
  mongodb_bind          = "${var.mongodb_bind}"
  mongodb_port          = "${var.mongodb_port}"
}

module "lb" {
  source                = "../modules/lb"
  infra_prefix          = "${var.infra_prefix}"
  lb_port               = "${var.lb_port}"
  app_port              = "${var.app_port}"
  zone                  = "${var.zone}"
  ext_app_ips           = "${module.app.instance_list}"
}

module "vpc" {
  source                = "../modules/vpc"
  infra_prefix          = "${var.infra_prefix}"
  app_port              = "${var.app_port}"
  ssh_sources_ranges    = "${var.ssh_sources_ranges}"
}
