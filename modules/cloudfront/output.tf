output "cf_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "acm_dns_validation_record" {
  value = aws_acm_certificate.main[0].domain_validation_options
}

output "acm_dns_validation_status" {
  value = aws_acm_certificate.main[0].status
}