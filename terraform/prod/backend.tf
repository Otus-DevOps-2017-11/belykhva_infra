terraform {
  backend "gcs" {
    bucket = "myprod-state-store-bucket"
    region = "europe-west1-b"
  }
}

