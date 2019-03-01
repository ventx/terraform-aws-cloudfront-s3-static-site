// Domain name for the new site
variable "site_name" {
  description = "Domain name for the new website"
}

// create hsoted zone or use existing
variable "create_hosted_zone" {
  description = "set 'true' for creating a new hosted zone, set 'false' to use existing"
  default     = false
}

// Variable for the root domain
variable "root_domain_name" {
  description = "Root domain name"
}

// index page for the static site
variable "index_document" {
  description = "Name for the indexfile"
  default     = "index.html"
}

// error page for the static site
variable "error_document" {
  description = "Name for the error document"
  default     = "404.html"
}

// IPv6 for CloudFront
variable "is_ipv6_enabled" {
  default     = "true"
  description = "State of CloudFront IPv6"
}

// TTL's for Cloudfront distribution
variable "cdn_min_ttl" {
  description = "Min TTL for Cloudfront distribution"
  default = "0"
}

variable "cdn_default_ttl" {
  description = "Default TTL for Cloudfront distribution"
  default = "1000"
}

variable "cdn_max_ttl" {
  description = "Max TTL for Cloudfront distribution"
  default = "86400"
}

