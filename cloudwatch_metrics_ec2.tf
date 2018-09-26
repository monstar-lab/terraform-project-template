## Cloudwatch(prd-web01)
resource "aws_cloudwatch_metric_alarm" "app_cpu" {
  count               = "${var.app_count}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-${element(aws_instance.app.*.tags.Name, count.index)}-CPUUtilization"
  alarm_description   = "${element(aws_instance.app.*.id, count.index)} cpu utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"
  treat_missing_data  = "missing"

  dimensions {
    InstanceId = "${element(aws_instance.app.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "app_status" {
  count               = "${var.app_count}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-${element(aws_instance.app.*.tags.Name, count.index)}-status-check-fail"
  alarm_description   = "${element(aws_instance.app.*.id, count.index)} status-check-fail"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  treat_missing_data  = "missing"

  dimensions {
    InstanceId = "${element(aws_instance.app.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "autorecovery" {
  depends_on          = ["aws_instance.app"]
  count               = "${var.app_count}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-autorecovery-${element(aws_instance.app.*.tags.Name, count.index)}"
  alarm_description   = "${element(aws_instance.app.*.id, count.index)} autorecovery"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "0"

  dimensions = {
    InstanceId = "${element(aws_instance.app.*.tags.Name, count.index)}"
  }

  alarm_actions             = ["arn:aws:automate:${var.region}:ec2:recover", "${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}
