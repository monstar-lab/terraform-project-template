resource "aws_cloudfront_origin_access_identity" "img_origin_access_identity" {
  comment = "${var.env}-${var.project_name}-${lookup(var.s3, "static_bucket_name")}"
}

resource "aws_cloudfront_distribution" "img_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.static.bucket_domain_name}"
    origin_id   = "S3-${aws_s3_bucket.static.bucket}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.img_origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.cf-logs.bucket_domain_name}"
    prefix          = "img"
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = ""

  aliases = ["${lookup(var.cloudfront, "img_domain_name")}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.static.bucket}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 60
    max_ttl                = 60
    compress               = true
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_distribution" "web_distribution" {
  depends_on      = ["aws_waf_web_acl.waf_acl"]
  enabled         = true
  is_ipv6_enabled = true
  comment         = ""

  aliases = ["${lookup(var.cloudfront, "web_domain_name")}"]

  origin {
    domain_name = "${aws_alb.nginx.dns_name}"
    origin_id   = "${aws_alb.nginx.name}"

    # custom_header {
    #   name  = "x-pre-shared-key"
    #   value = "${var.x-pre-shared-key}"
    # }

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "match-viewer"
      origin_read_timeout      = 60
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # viewer_certificate {
  #   cloudfront_default_certificate = false
  #   acm_certificate_arn            = "${var.cf_certificate_arn}"
  #   ssl_support_method             = "sni-only"
  #   minimum_protocol_version       = "TLSv1.1_2016"
  # }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = "${aws_alb.nginx.name}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }

      headers = ["Accept", "Accept-Language", "Authorization", "CloudFront-Forwarded-Proto", "Host", "Origin", "Referer", "User-agent"]
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    max_ttl                = 0
    default_ttl            = 0
    compress               = true
  }
  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.cf-logs.bucket_domain_name}"
    prefix          = "web"
  }
  web_acl_id = "${aws_waf_web_acl.waf_acl.id}"
}
