resource "aws_flow_log" "flowlogs" {
  log_destination      = "arn:aws:s3:::${var.s3_bucket_name}"
  log_destination_type = "s3"
  vpc_id               = var.vpc_id
  traffic_type         = "ALL"
}