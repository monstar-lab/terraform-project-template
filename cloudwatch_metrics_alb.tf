#########################################
# Application Load Balancer CloudWatch Alarm
#########################################
resource "aws_cloudwatch_metric_alarm" "nginx-alb-requestCount" {
  depends_on          = ["aws_alb.nginx", "aws_alb_target_group.nginx"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-nginx-ALB-RequestCount"
  alarm_description   = "Nginx ALB RequestCount"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"

  threshold = "500"

  dimensions {
    LoadBalancer = "${aws_alb.nginx.arn_suffix}"
    TargetGroup  = "${aws_alb_target_group.nginx.arn_suffix}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "nginx-alb-UnHealthCount" {
  depends_on          = ["aws_alb.nginx", "aws_alb_target_group.nginx"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-nginx-ALB-UnHealthyHostCount"
  alarm_description   = "Nginx ALB UnHealthyHostCount"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"

  threshold = "1"

  dimensions {
    LoadBalancer = "${aws_alb.nginx.arn_suffix}"
    TargetGroup  = "${aws_alb_target_group.nginx.arn_suffix}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "nginx-alb-ELB_4XX_Count" {
  depends_on          = ["aws_alb.nginx", "aws_alb_target_group.nginx"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-nginx-ALB-ELB_4XX_Count"
  alarm_description   = "Nginx ALB ELB_4XX_Count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"
  threshold           = "500"

  dimensions {
    LoadBalancer = "${aws_alb.nginx.arn_suffix}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "nginx-alb-ELB_5XX_Count" {
  depends_on          = ["aws_alb.nginx", "aws_alb_target_group.nginx"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-nginx-ALB-ELB_5XX_Count"
  alarm_description   = "Nginx ALB ELB_5XX_Count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"
  threshold           = "1"

  dimensions {
    LoadBalancer = "${aws_alb.nginx.arn_suffix}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "nginx-alb-Target_4XX_Count" {
  depends_on          = ["aws_alb.nginx", "aws_alb_target_group.nginx"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-nginx-ALB-Target_4XX_Count"
  alarm_description   = "Nginx ALB Target_4XX_Count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"
  threshold           = "500"

  dimensions {
    LoadBalancer = "${aws_alb.nginx.arn_suffix}"
    TargetGroup  = "${aws_alb_target_group.nginx.arn_suffix}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "nginx-alb-Target_5XX_Count" {
  depends_on          = ["aws_alb.nginx", "aws_alb_target_group.nginx"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-nginx-ALB-Target_5XX_Count"
  alarm_description   = "Nginx ALB Target_5XX_Count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"
  threshold           = "1"

  dimensions {
    LoadBalancer = "${aws_alb.nginx.arn_suffix}"
    TargetGroup  = "${aws_alb_target_group.nginx.arn_suffix}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "nginx-alb-TargetResponseTime" {
  depends_on          = ["aws_alb.nginx", "aws_alb_target_group.nginx"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-nginx-ALB-TargetResponseTime"
  alarm_description   = "Nginx ALB TargetResponseTime"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"

  threshold = "3"

  dimensions {
    LoadBalancer = "${aws_alb.nginx.arn_suffix}"
    TargetGroup  = "${aws_alb_target_group.nginx.arn_suffix}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}
