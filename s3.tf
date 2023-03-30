resource "aws_s3_bucket" "security" {
  bucket = "secutiry-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "secutiry-${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "security_encryption" {
  bucket = aws_s3_bucket.security.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.key_s3.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "security" {
  bucket = aws_s3_bucket.security.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.security.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.security.id}",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudtrail.cloudtrail.arn}"
                }
            }
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.security.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudtrail.cloudtrail.arn}",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOF
}
