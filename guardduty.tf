resource "aws_guardduty_detector" "guardduty" {
  enable = true
}

resource "aws_guardduty_publishing_destination" "test" {
  detector_id     = aws_guardduty_detector.guardduty.id
  destination_arn = aws_s3_bucket.security.arn
  kms_key_arn     = aws_kms_key.gd_key.arn

  depends_on = [
    aws_s3_bucket_policy.bucket_policy,
  ]
}