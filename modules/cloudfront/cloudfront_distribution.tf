

resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = "${var.origin_domain}"
    origin_id   = "${var.origin_id}"
  }

  enabled = "${var.enable}"
  is_ipv6_enabled = true
  default_root_object = ""

  aliases = "${var.aliases}"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.origin_id}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    max_ttl                = 31536000
    default_ttl            = 86400

  }

  restrictions  {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_All"
}