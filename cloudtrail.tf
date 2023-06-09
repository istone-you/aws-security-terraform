resource "aws_cloudtrail" "cloudtrail" {
  name                          = "cloudtrail-${data.aws_caller_identity.current.account_id}"
  s3_bucket_name                = aws_s3_bucket.security.id
  include_global_service_events = true
  is_multi_region_trail         = true
  kms_key_id                    = aws_kms_key.key_s3.arn

  depends_on = [
    aws_s3_bucket_policy.bucket_policy,
    aws_kms_key.key_s3
  ]
}