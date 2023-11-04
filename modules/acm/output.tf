output "cert_arn" {
  value = aws_acm_certificate.cert.arn
}

output "cert_domain_zone_id" {
  value = data.aws_route53_zone.zone.zone_id
}

output "cert_domain_name" {
  value = var.route53_domain
}