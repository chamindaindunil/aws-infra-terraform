terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = var.aws_region
  shared_config_files      = ["/Users/chamindaindunil/.aws/config"]
  shared_credentials_files = ["/Users/chamindaindunil/.aws/credentials"]
  # profile                  = "default"

  default_tags {
    tags = {
      name        = var.project
      created     = "terraform"
      Environment = var.environment
    }
  }
}

# cloudfront region
provider "aws" {
  alias                    = "useast1"
  region                   = "us-east-1"
  shared_config_files      = ["/Users/chamindaindunil/.aws/config"]
  shared_credentials_files = ["/Users/chamindaindunil/.aws/credentials"]
  # profile                  = "default"

  default_tags {
    tags = {
      name        = var.project
      created     = "terraform"
      Environment = var.environment
    }
  }
}
