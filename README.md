# Terraform-aws-cloudfront-s3-static-site

## Purpose

Create a static website with S3 bucket as origin and deliver it with a Cloudfront distribution.

### Sidenotes
- The s3 bucket will be created 'private' and no static website hosting will be enabled.
- The certificate and the validation will be made in 'us-east-1' because no other region is currently possible.
- All the arguments with default values are optional

After creating the resources, you have to place your content in your bucket ... that's it.



## Argument Reference

- `site_name` 
    >Domain name for the new website. 
    >This is also used to create the name of the bucket and the caller id (current Account ID).

- `create_hosted_zone` 
    >Optional: If set to 'true' the named root domain will be created. Defaults to 'false'

- `profile`
    >Profile which to use for creation of resources
    
- `root_domain_name` 
    >Root domain name for the site

- `region` 
    >AWS region to use for the resources

- `index_document` 
    >Optional: Name of the index file. Defaults to *index.html*

- `error_document` 
    >Optional: Name of the error file. Defaults to *404.html*



## Attribute Reference

- `bucket_arn` 
    >ARN of the used s3 bucket

- `bucket_region` 
    >AWS Region for the S3 Bucket

- `bucket_name` 
    >Name of the S3 Bucket

- `profile` 
    >which is used to create the resources

- `site_cdn_arn` 
    >ARN of the cloudfront distribution

- `site_cdn_domain` 
    >Domain name of the Cloudfront distribution

- `site_cdn_origin` 
    >The Cloudfront distribution origin

- `site_certificate_arn` 
    >ARN of Certificate for the website

- `site_url` 
    >URL of the static website


## Example Usage

```



resource "aws_s3_bucket_object" "index_file" {
  bucket = "${module.site_bucket.bucket_name}"
  key = "index.html"
  source = "/path/to/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error_file" {
  bucket = "${module.site_bucket.bucket_name}"
  key = "404.html"
  source = "/path/to/404.html"
  content_type = "text/html"
```