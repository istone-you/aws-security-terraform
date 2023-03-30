resource "aws_cloudtrail" "cloudtrail" {
  name                          = "cloudtrail-${data.aws_caller_identity.current.account_id}"
  s3_bucket_name                = var.s3_bucket_name
  include_global_service_events = true
  is_multi_region_trail         = true
  kms_key_id                    = var.s3_kms_arn
}