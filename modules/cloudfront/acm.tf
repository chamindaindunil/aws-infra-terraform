provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "main" {
  provider = aws.us_east_1
  count    = var.cf_custom_domain != "" ? 1 : 0

  domain_name       = var.cf_custom_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

