resource "aws_inspector_assessment_target" "inspector" {
  name               = "inspector-target-${data.aws_caller_identity.current.account_id}"
  resource_group_arn = aws_inspector_resource_group.inspector.arn
}

# "inspector"タグがtrueのインスタンスを対象にします。
resource "aws_inspector_resource_group" "inspector" {
  tags = {
    inspector = "true"
  }
}
