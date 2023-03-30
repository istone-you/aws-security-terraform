resource "aws_flow_log" "flowlogs" {
  log_group_name = "flow-logs"
  iam_role_arn = "${aws_iam_role.test_role.arn}"
  vpc_id = "${var.vpc_id}"
  traffic_type = "ALL"
}