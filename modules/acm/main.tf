# AWS ACM for site TLS certs. provision TLS cert manually to avoid tf stack creation deplay.
data "aws_route53_zone" "zone" {
  name         = var.route53_domain
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name = var.route53_domain
  subject_alternative_names = [
    "${var.route53_domain}",
    "*.${var.route53_domain}"
  ]
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

