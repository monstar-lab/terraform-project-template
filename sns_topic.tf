###################################
# SNS Topic for cw-alert
###################################
resource "aws_sns_topic" "cw-alert" {
  name         = "${var.env}-${var.project_name}-cloudwatch-alert"
  display_name = "${var.env}-${var.project_name}-cloudwatch-alert"
}
