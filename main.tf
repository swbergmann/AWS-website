locals {
  s3_bucket_name = "website-backend-2384209"
}

# resource "aws_instance" "instance1" {
#     ami = "ami-0f7204385566b32d0"
#     instance_type = "t2.micro"
# }

# must be empty to be deleted
resource "aws_s3_bucket" "main" {
  bucket = local.s3_bucket_name
}

resource "aws_cloudfront_distribution" "main" {
  enabled = true
  default_root_object = "index.html"
  is_ipv6_enabled = true
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
    cached_methods = [ "GET", "HEAD", "OPTIONS" ]
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    target_origin_id = aws_s3_bucket.main.bucket
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
    origin_id = aws_s3_bucket.main.bucket
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

resource "aws_cloudfront_origin_access_control" "main" {
  name = "s3-cloudfront-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

data "aws_iam_policy_document" "cloudfront_oac_access" {
  statement {
    principals {
      identifiers = [ "cloudfront.amazonaws.com" ]
      type = "Service"
    }

    actions = ["s3:GetObject"]
    resources = [ "${aws_s3_bucket.main.arn}/*" ]

    condition {
      test = "StringEquals"
      values = [ aws_cloudfront_distribution.main.arn ]
      variable = "AWS:SourceArn"
    }
  }
}

#apply policy to S3 bucket
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.cloudfront_oac_access.json
}