resource "aws_guardduty_detector" "guardduty" {
  enable = true
}

resource "aws_guardduty_publishing_destination" "test" {
  detector_id     = aws_guardduty_detector.guardduty.id
  destination_arn = "arn:aws:s3:::${var.s3_bucket_name}"
  kms_key_arn     = var.s3_kms_arn
}