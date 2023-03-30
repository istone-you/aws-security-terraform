resource "aws_iam_policy" "config" {
  name = "build-frontend-project-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.security.id}/*"
        ],
        "Condition" : {
          "StringLike" : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetBucketAcl"
        ],
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.security.id}"
      }
    ]
  })
}

resource "aws_iam_role" "config" {
  name = "aws-config-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]

  })

  managed_policy_arns = [aws_iam_policy.config.arn]

  tags = {
    Name = "aws-config-role"
  }
}
