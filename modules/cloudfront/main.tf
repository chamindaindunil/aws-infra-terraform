locals {
  apigw_origin_id    = "${var.project}-apigw"
  s3_games_origin_id = "${var.project}-games-s3-origin"
  s3_site_origin_id  = "${var.project}-site-s3-origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  #Site s3 origin
  origin {
    domain_name         = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id           = local.s3_site_origin_id
    connection_attempts = 3
    connection_timeout  = 10
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.site_bucket.cloudfront_access_identity_path
    }
  }

  #Games s3 origin
  origin {
    domain_name         = aws_s3_bucket.games.bucket_regional_domain_name
    origin_id           = local.s3_games_origin_id
    connection_attempts = 3
    connection_timeout  = 10
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.games_bucket.cloudfront_access_identity_path
    }
  }

  #http apigw origin
  origin {
    domain_name         = var.http_apigw_url
    origin_id           = local.apigw_origin_id
    connection_attempts = 3
    connection_timeout  = 10

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = false
  aliases         = var.cf_enable_acm_cert ? [var.cf_custom_domain] : null

  web_acl_id = var.waf_acl_id

  comment             = "Main APP CDN with WAF"
  default_root_object = "index.html"
  price_class         = "PriceClass_200"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "${var.project}-cflog.s3.amazonaws.com"
  #   prefix          = "${var.project}-cflog"
  # }

  # default: site 
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_site_origin_id

    min_ttl                = 0
    default_ttl            = 360
    max_ttl                = 3600
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id            = aws_cloudfront_cache_policy.main.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.main.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.main.id
  }

  #games
  ordered_cache_behavior {
    path_pattern     = "/games/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_games_origin_id

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id            = aws_cloudfront_cache_policy.main.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.main.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.main.id
  }

  #api gw
  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.apigw_origin_id

    min_ttl                = 0
    default_ttl            = 60
    max_ttl                = 3600
    compress               = false
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id            = aws_cloudfront_cache_policy.main.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.main.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.main.id
  }

  #api gw - auth
  ordered_cache_behavior {
    path_pattern     = "/auth/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.apigw_origin_id

    min_ttl                = 0
    default_ttl            = 60
    max_ttl                = 3600
    compress               = false
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id            = aws_cloudfront_cache_policy.main.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.main.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.main.id
  }

  # Cloudfront only supports us-east-1 for cerificate selection. Make sure to create acm in same region to create stack.
  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = var.cf_enable_acm_cert ? aws_acm_certificate.main[0].arn : null
    ssl_support_method             = var.cf_enable_acm_cert ? "sni-only" : null
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" #whitelist
      locations        = "none" #["LK", "SG"]
    }
  }

  depends_on = [aws_s3_bucket_policy.games_bucket_policy, aws_s3_bucket_policy.site_bucket_policy]
}


