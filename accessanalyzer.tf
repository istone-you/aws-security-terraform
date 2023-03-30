resource "aws_accessanalyzer_analyzer" "example" {
  analyzer_name = "IAMAccessAnalyzer-${data.aws_caller_identity.current.account_id}"
}