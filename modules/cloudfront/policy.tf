resource "aws_cloudfront_origin_request_policy" "main" {
  name    = "main-request-policy"
  comment = "common request policy"
  cookies_config {
    cookie_behavior = "all"
  }

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = [
        "Content-Type",
        "Content-Length",
        "Origin"
      ]
    }
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}

resource "aws_cloudfront_cache_policy" "main" {
  name        = "main-cache-policy"
  comment     = "common cache comment"
  min_ttl     = 0
  default_ttl = 60
  max_ttl     = 3600

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "all"
    }

    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Accept-Encoding",
          "Authorization",
          "idempotency-key"
        ]
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_response_headers_policy" "main" {
  name    = "security-policy"
  comment = "comment security headers"

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "SAMEORIGIN"
      override     = true
    }

    referrer_policy {
      referrer_policy = "same-origin"
      override        = true
    }

    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }

    strict_transport_security {
      access_control_max_age_sec = "63072000"
      include_subdomains         = true
      preload                    = true
      override                   = true
    }

    # content_security_policy {
    #   content_security_policy = "frame-ancestors 'none'; default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'"
    #   override                = false
    # }
  }

  #   custom_headers_config {
  #     items {
  #       header = "permissions-policy"
  #       override = false
  #       value = "accelerometer=(), geolocation=(), gyroscope=(),"
  #     }
  #   }
}