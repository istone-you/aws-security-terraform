variable "vpc_id" {}
variable "s3_bucket_name" {}
variable "s3_kms_arn" {}

data "aws_caller_identity" "current" {}