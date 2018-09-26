#########################################
# RDS CloudWatch Alarm
#########################################
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  depends_on          = ["aws_db_instance.mysql-master"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerCPUUtilization-db-master"
  alarm_description   = "Database server CPU utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.mysql-master.id}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_connection" {
  depends_on          = ["aws_db_instance.mysql-master"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerConnection-db-master"
  alarm_description   = "Database server Connection"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.mysql-master.id}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_disk_queue" {
  depends_on          = ["aws_db_instance.mysql-master"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerDiskQueueDepth-db-master"
  alarm_description   = "Database server disk queue depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.mysql-master.id}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_disk_free" {
  depends_on          = ["aws_db_instance.mysql-master"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerFreeStorageSpace-db-master"
  alarm_description   = "Database server free storage space"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "50000000"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.mysql-master.id}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_memory_free" {
  depends_on          = ["aws_db_instance.mysql-master"]
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerFreeableMemory-db-master"
  alarm_description   = "Database server freeable memory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "128000000"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.mysql-master.id}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

#########################################
# RDS ReadReplica CloudWatch Alarm
#########################################
resource "aws_cloudwatch_metric_alarm" "database_cpu_readreplica_a" {
  depends_on          = ["aws_db_instance.mysql-replica-a"]
  count               = "${lookup(var.rds-replica, "readreplica_count_a")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerCPUUtilization-${format("replica-a-%02d", count.index + 1)}"
  alarm_description   = "Database server CPU utilization for ${format("replica-a-%02d", count.index + 1)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-a.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_cpu_readreplica_c" {
  depends_on          = ["aws_db_instance.mysql-replica-c"]
  count               = "${lookup(var.rds-replica, "readreplica_count_c")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerCPUUtilization-${format("replica-c-%02d", count.index + 1)}"
  alarm_description   = "Database server CPU utilization for ${format("replica-c-%02d", count.index + 1)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-c.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_connection_readreplica_a" {
  depends_on          = ["aws_db_instance.mysql-replica-a"]
  count               = "${lookup(var.rds-replica, "readreplica_count_a")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerConnection-${format("replica-a-%02d", count.index + 1)}"
  alarm_description   = "Database server Connection for ${format("replica-a-%02d", count.index + 1)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-a.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_connection_readreplica_c" {
  depends_on          = ["aws_db_instance.mysql-replica-c"]
  count               = "${lookup(var.rds-replica, "readreplica_count_c")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerConnection-${format("replica-c-%02d", count.index + 1)}"
  alarm_description   = "Database server Connection for ${format("replica-c-%02d", count.index + 1)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-c.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_disk_queue_readreplica_a" {
  depends_on          = ["aws_db_instance.mysql-replica-a"]
  count               = "${lookup(var.rds-replica, "readreplica_count_a")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerDiskQueueDepth-${format("replica-a-%02d", count.index + 1)}"
  alarm_description   = "Database server disk queue depth for ${format("replica-a-%02d", count.index + 1)}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-a.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_disk_queue_readreplica_c" {
  depends_on          = ["aws_db_instance.mysql-replica-c"]
  count               = "${lookup(var.rds-replica, "readreplica_count_c")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerDiskQueueDepth-${format("replica-c-%02d", count.index + 1)}"
  alarm_description   = "Database server disk queue depth for ${format("replica-c-%02d", count.index + 1)}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-c.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_disk_free_readreplica_a" {
  depends_on          = ["aws_db_instance.mysql-replica-a"]
  count               = "${lookup(var.rds-replica, "readreplica_count_a")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerFreeStorageSpace-${format("replica-a-%02d", count.index + 1)}"
  alarm_description   = "Database server free storage space for ${format("replica-a-%02d", count.index + 1)}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "50000000"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-a.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_disk_free_readreplica_c" {
  depends_on          = ["aws_db_instance.mysql-replica-c"]
  count               = "${lookup(var.rds-replica, "readreplica_count_c")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerFreeStorageSpace-${format("replica-c-%02d", count.index + 1)}"
  alarm_description   = "Database server free storage space for ${format("replica-c-%02d", count.index + 1)}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "50000000"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-c.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_memory_free_readreplica_a" {
  depends_on          = ["aws_db_instance.mysql-replica-a"]
  count               = "${lookup(var.rds-replica, "readreplica_count_a")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerFreeableMemory-${format("replica-a-%02d", count.index + 1)}"
  alarm_description   = "Database server free memory for ${format("replica-a-%02d", count.index + 1)}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "128000000"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-a.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_memory_free_readreplica_c" {
  depends_on          = ["aws_db_instance.mysql-replica-c"]
  count               = "${lookup(var.rds-replica, "readreplica_count_c")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerFreeableMemory-${format("replica-c-%02d", count.index + 1)}"
  alarm_description   = "Database server free memory for ${format("replica-c-%02d", count.index + 1)}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "128000000"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-c.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_connection_readreplica_a_external" {
  depends_on          = ["aws_db_instance.mysql-replica-a"]
  count               = "${lookup(var.rds-replica, "readreplica_count_a")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerConnection-${format("replica-a-%02d", count.index + 1)}-external"
  alarm_description   = "Database server Connection for ${format("replica-a-%02d", count.index + 1)}-external"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-a.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "database_connection_readreplica_c_external" {
  depends_on          = ["aws_db_instance.mysql-replica-c"]
  count               = "${lookup(var.rds-replica, "readreplica_count_c")}"
  alarm_name          = "alarm-${var.env}-${var.project_name}-DatabaseServerConnection-${format("replica-c-%02d", count.index + 1)}-external"
  alarm_description   = "Database server Connection for ${format("replica-c-%02d", count.index + 1)}-external"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"

  dimensions {
    DBInstanceIdentifier = "${element(aws_db_instance.mysql-replica-c.*.id, count.index)}"
  }

  alarm_actions             = ["${aws_sns_topic.cw-alert.arn}"]
  ok_actions                = ["${aws_sns_topic.cw-alert.arn}"]
  insufficient_data_actions = []
}
