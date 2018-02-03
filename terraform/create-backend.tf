provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_storage_bucket" "state-store" {
  count    = "2"
  name     = "${element(var.gcs_buckets, count.index)}"
  location = "EU"
}
