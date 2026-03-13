terraform {
  backend "s3" {
    bucket                      = "REPLACE_ME_TF_STATE_BUCKET"
    key                         = "hetzner/terraform.tfstate"
    region                      = "REPLACE_ME_REGION"
    endpoint                    = "REPLACE_ME_S3_ENDPOINT"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}
