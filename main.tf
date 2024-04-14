locals {
  # value must be globally unique
  s3_bucket_name = "website-backend-6571963"
}

# empty the S3 bucket manually before it can be deleted by terraform
resource "aws_s3_bucket" "backend" {
  bucket = local.s3_bucket_name
}

resource "aws_cloudfront_distribution" "frontend" {
  enabled = true
  default_root_object = "index.html"
  is_ipv6_enabled = true
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
    cached_methods = [ "GET", "HEAD", "OPTIONS" ]
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    target_origin_id = aws_s3_bucket.backend.bucket
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = aws_s3_bucket.backend.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id = aws_s3_bucket.backend.bucket
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# restrict access to and make S3 backend more secure
# cloudfront distribution uses this OAC with an S3 as origin
resource "aws_cloudfront_origin_access_control" "oac" {
  name = "cloudfront-oac-to-S3"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

# describes the IAM policy
# is expected by the S3 bucket policy (resource below)
data "aws_iam_policy_document" "document" {
  statement {
    principals {
      identifiers = [ "cloudfront.amazonaws.com" ]
      type = "Service"
    }

    actions = ["s3:GetObject"]
    resources = [ "${aws_s3_bucket.backend.arn}/*" ]

    condition {
      test = "StringEquals"
      values = [ aws_cloudfront_distribution.frontend.arn ]
      variable = "AWS:SourceArn"
    }
  }
}

#apply the IAM policy to the S3 bucket
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.backend.id
  policy = data.aws_iam_policy_document.document.json
}

#automatically upload the files to S3
resource "aws_s3_object" "auto_upload" {
  bucket = aws_s3_bucket.backend.id

  for_each = fileset("s3_content/", "**/*.*")

  key = each.value
  source = "s3_content/${each.value}"
  content_type = each.value
}