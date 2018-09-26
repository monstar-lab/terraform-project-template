#########################################
# ElastiCache CloudWatch Alarm
#########################################
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  depends_on          = ["aws_elasticache_replication_group.cache"]
  count               = "${lookup(var.cache, "number_cache_clusters")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-CacheCluster00${count.index + 1}CPUUtilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    CacheClusterId = "${aws_elasticache_replication_group.cache.id}-00${count.index + 1}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  depends_on          = ["aws_elasticache_replication_group.cache"]
  count               = "${lookup(var.cache, "number_cache_clusters")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-CacheCluster00${count.index + 1}FreeableMemory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = "10000000"

  dimensions {
    CacheClusterId = "${aws_elasticache_replication_group.cache.id}-00${count.index + 1}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}
