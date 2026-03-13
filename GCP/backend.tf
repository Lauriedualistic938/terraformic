terraform {
  backend "gcs" {
    bucket = "REPLACE_ME_TF_STATE_BUCKET"
    prefix = "gcp"
  }
}
