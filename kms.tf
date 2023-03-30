resource "aws_kms_key" "key_s3" {
  description = "ECS pipeline artifact Key"
  is_enabled  = true
  policy = jsonencode({
    Id = "example"
    Statement = [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow CloudTrail to Use the Key",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudtrail.amazonaws.com"
        },
        "Action" : [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ],
        "Resource" : "*"
      },
      {
        "Sid": "Allow GuardDuty to encrypt findings",
        "Effect": "Allow",
        "Principal": {
          "Service": "guardduty.amazonaws.com"
        },
        "Action": "kms:GenerateDataKey",
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}",
            "aws:SourceArn": "${aws_guardduty_detector.guardduty.arn}"
          }
        }
      },
      {
        "Sid" : "AWSConfigKMSPolicy",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "config.amazonaws.com"
        },
        "Action" : [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Resource" : "*"
      }
    ]
    Version = "2012-10-17"
  })
  key_usage = "ENCRYPT_DECRYPT"
  tags = {
    Name = "security-s3-key"
  }
}

resource "aws_kms_alias" "key_alias_s3" {
  name          = "alias/security-s3-key"
  target_key_id = aws_kms_key.key_s3.key_id
}
