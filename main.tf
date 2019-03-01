
data "aws_caller_identity" "current" {}

// s3 Bucket with Website settings
resource "aws_s3_bucket" "site_bucket" {
  bucket = "${var.site_name}-${data.aws_caller_identity.current.account_id}"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "site_bucket_policy" {
  bucket = "${aws_s3_bucket.site_bucket.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

resource "aws_route53_zone" "hosted_zone" {
  count = "${var.create_hosted_zone}"
  name  = "${var.root_domain_name}"
}

data "aws_route53_zone" "zone" {
  name         = "${var.root_domain_name}"
  private_zone = false
}

// Creating new provider for ACM in us-east-1
provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}

// create certificate in us-east-1 using alias
resource "aws_acm_certificate" "cert" {
  provider          = "aws.acm_provider"
  domain_name       = "${var.site_name}"
  validation_method = "DNS"
}

// create a cname record for cert validation
resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

// validate the cert in us-east-1
resource "aws_acm_certificate_validation" "cert" {
  provider                = "aws.acm_provider"
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

// origin Acces Identity for Cloudfront
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Identity to Access S3 Bucket"
}

// S3 Bucket Policy
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.site_name}-${data.aws_caller_identity.current.account_id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.site_name}-${data.aws_caller_identity.current.account_id}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

// create cloudfront distribution
resource "aws_cloudfront_distribution" "site_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.site_bucket.bucket_domain_name}"
    origin_id   = "${var.site_name}-origin"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = "${var.is_ipv6_enabled}"
  aliases             = ["${var.site_name}"]
  price_class         = "PriceClass_100"
  default_root_object = "${var.index_document}"

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH",
      "POST",
      "PUT",
    ]

    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.site_name}-origin"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 0
    default_ttl            = 1000
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.cert.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

// create an alias record pointing to CloudFront
resource "aws_route53_record" "dnsrecord" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "${var.site_name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.site_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.site_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}
