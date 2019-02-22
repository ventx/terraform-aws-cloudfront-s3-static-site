// Domain name for the new site
variable "site_name" {
  description = "Domain name for the new website"
}

// Profile to use for the AWS connection
variable "profile" {
  description = "Profile to use for AWS connection"
}

// AWS region to use
variable "aws_region" {
  description = "Region to use"
}

// create hsoted zone or use existing
variable "create_hosted_zone" {
  description = "set 'true' for creating a new hosted zone, set 'false' to use existing"
  default = false
}

// Variable for the root domain
variable "root_domain_name" {
  description = "Root domain name"
}

// index page for the static site
variable "index_document" {
  description = "Name for the indexfile"
  default = "index.html"
}

// error page for the static site
variable "error_document" {
  description = "Name for the error document"
  default = "404.html"
}