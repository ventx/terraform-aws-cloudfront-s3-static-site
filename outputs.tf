// bucket name
output "bucket_name" {
  value = "${aws_s3_bucket.site_bucket.bucket}"
}

// bucket arn
output "bucket_arn" {
  value = "${aws_s3_bucket.site_bucket.arn}"
}

// bucket region
output "bucket_region" {
  value = "${aws_s3_bucket.site_bucket.region}"
}

// Cloudfront root object
output "site_root_object" {
  value = "${aws_cloudfront_distribution.site_distribution.default_root_object}"
}

// cloudfront domain name
output "site_cdn_domain" {
  value = "${aws_cloudfront_distribution.site_distribution.domain_name}"
}

// Cloufront arn
output "site_cdn_arn" {
  value = "${aws_cloudfront_distribution.site_distribution.arn}"
}

// Cloudfront content origin
output "site_cdn_origin" {
  value = "${aws_cloudfront_distribution.site_distribution.origin}"
}

output "site_certificate_arn" {
  value = "${aws_acm_certificate.cert.arn}"
}

output "site_url" {
  value = "${aws_route53_record.dnsrecord.fqdn}"
}

