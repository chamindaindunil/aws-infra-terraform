terraform {
  backend "s3" {
    bucket               = "mr2-tf-state"
    workspace_key_prefix = "dmr-prod"
    key                  = "terraform.tfstate"
    region               = "ap-southeast-1"
  }
}
