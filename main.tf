# Task 1.
# Host a simple webpage on AWS using Terraform 
# to write replicable Infrastructure as Code (IaC).

locals {
  # Value must be globally unique:
  s3_bucket_name = "website-backend-6571963"
}

# S3 bucket used as backend to store the static website files.
resource "aws_s3_bucket" "backend" {
  bucket = local.s3_bucket_name
}

# Cloudfront distribution used as frontend
# to globally cache and serve the website to users.
resource "aws_cloudfront_distribution" "frontend" {
  enabled = true

  # Specify the landing page:
  default_root_object = "index.html"
  is_ipv6_enabled = true

  # AWS Managed Caching Policy (CachingOptimized) optimizes cache efficiency.
  default_cache_behavior {
    # Using the CachingOptimized managed policy ID:
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    # Which HTTP methods cloudfront processes and forwards to the S3 bucket (origin):
    allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
    # Cloudfront caches the response to requests using these HTTP methods:
    cached_methods = [ "GET", "HEAD", "OPTIONS" ]
    target_origin_id = aws_s3_bucket.backend.bucket
    # Attempts to access the files in the origin will be redirected to HTTPS (i.e. from unsecure HTTP).
    # Increases application security because nobody can use HTTP only.
    viewer_protocol_policy = "redirect-to-https"
  }

  # Specify the cloudfront origin (the S3 backend) and OAC ID.
  origin {
    domain_name = aws_s3_bucket.backend.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id = aws_s3_bucket.backend.bucket
  }

  # Allow global access as per requirements.
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL configuration:
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Manages cloudfront origin access control (increase backend security).
# Cloudfront distribution uses this OAC with the S3 bucket as origin.
resource "aws_cloudfront_origin_access_control" "oac" {
  name = "cloudfront-oac-to-S3"
  origin_access_control_origin_type = "s3"
  # Which requests cloudfront authenticates:
  signing_behavior = "always"
  # How cloudfront authenticates request:
  signing_protocol = "sigv4"
}

# Describes the IAM policy document.
# This document is expected by the S3 bucket policy (the resource below this).
data "aws_iam_policy_document" "document" {
  statement {
    principals {
      identifiers = [ "cloudfront.amazonaws.com" ]
      type = "Service"
    }

    # Allow this action
    actions = ["s3:GetObject"]

    # Apply this statement to this resource ARNs and allow
    # cloudfront to access all objects inside the S3 bucket.
    resources = [ "${aws_s3_bucket.backend.arn}/*" ]

    # Limit instruction application to only this "frontend" cloudfront distribution.
    condition {
      test = "StringEquals"
      values = [ aws_cloudfront_distribution.frontend.arn ]
      variable = "AWS:SourceArn"
    }
  }
}

# Apply the IAM policy to the S3 bucket (our backend).
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.backend.id
  policy = data.aws_iam_policy_document.document.json
}

# Automatically upload all website files from "s3_content/" to the S3 bucket
# or destroy all website files in the S3 bucket, when destroying the resource.
resource "aws_s3_object" "auto_upload" {
  bucket = aws_s3_bucket.backend.id

  for_each = fileset("s3_content/", "**/*.*")

  key = each.value
  source = "s3_content/${each.value}"
  content_type = each.value
}