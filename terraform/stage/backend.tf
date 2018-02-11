terraform {
  backend "gcs" {
    bucket = "mystage-state-store-bucket"
    region = "europe-west1-b"
  }
}

