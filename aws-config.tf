resource "aws_config_configuration_recorder" "awsconfig" {
  name     = "config-recorder-${data.aws_caller_identity.current.account_id}"
  role_arn = aws_iam_policy.config.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "awsconfig" {
  name       = aws_config_configuration_recorder.awsconfig.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.awsconfig]
}


resource "aws_config_delivery_channel" "awsconfig" {
  name           = "awsconfig-${data.aws_caller_identity.current.account_id}"
  s3_bucket_name = aws_s3_bucket.security.id
  depends_on     = [aws_config_configuration_recorder.awsconfig]
  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }
}