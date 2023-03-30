resource "aws_flow_log" "flowlogs" {
  log_destination      = aws_s3_bucket.security.arn
  log_destination_type = "s3"
  vpc_id               = var.vpc_id
  traffic_type         = "ALL"
}