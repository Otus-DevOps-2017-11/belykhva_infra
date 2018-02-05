variable "project" {
  default               = "infra-188819"
  description           = "Project ID"
}

variable "region" {
  default               = "europe-west1"
  description           = "Default Region"
}

variable "gcs_buckets" {
  default               = ["myprod-state-store-bucket", "mystage-state-store-bucket"]
  description           = "Bucket's list"
}
