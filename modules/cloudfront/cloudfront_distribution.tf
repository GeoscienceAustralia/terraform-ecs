

resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = "${var.origin_domain}"
    origin_id   = "${var.origin_id}"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = "${var.enable}"
  is_ipv6_enabled = "${var.enable_ipv6}"
  default_root_object = ""

  aliases = "${var.aliases}"

  default_cache_behavior {
    allowed_methods  = "${var.default_allowed_methods}"
    cached_methods   = "${var.default_cached_methods}"
    target_origin_id = "${var.origin_id}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = "${var.min_ttl}"
    max_ttl                = "${var.max_ttl}"
    default_ttl            = "${var.default_ttl}"

  }

  restrictions  {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "${var.price_class}"
}