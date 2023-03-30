resource "aws_kms_key" "key_s3" {
  description = "ECS pipeline artifact Key"
  is_enabled  = true
  policy      = data.aws_iam_policy_document.key_s3.json
  key_usage   = "ENCRYPT_DECRYPT"
  tags = {
    Name = "security-s3-key"
  }
}

resource "aws_kms_alias" "key_alias_s3" {
  name          = "alias/security-s3-key"
  target_key_id = aws_kms_key.key_s3.key_id
}

data "aws_iam_policy_document" "key_s3" {
  version = "2012-10-17"
  # デフォルトキーポリシー
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}