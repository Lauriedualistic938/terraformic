terraform {
  backend "s3" {
    bucket         = "REPLACE_ME_TF_STATE_BUCKET"
    key            = "aws/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "REPLACE_ME_TF_STATE_LOCK_TABLE"
    encrypt        = true
  }
}
