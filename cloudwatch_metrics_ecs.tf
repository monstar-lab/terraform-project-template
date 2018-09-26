#########################################
# ECS Cluster CloudWatch Alarm
#########################################
resource "aws_cloudwatch_metric_alarm" "cluster_instance_high_cpu" {
  alarm_name          = "alarm-${var.env}-${var.project_name}-cluster-CPUReservation-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.cluster_instance_scale_up.arn}", "${aws_sns_topic.cw-alert.arn}"]
  ok_actions    = ["${aws_sns_topic.cw-alert.arn}"]
  depends_on    = ["aws_cloudwatch_metric_alarm.cluster_instance_high_cpu"]
}

resource "aws_cloudwatch_metric_alarm" "cluster_instance_low_cpu" {
  alarm_name          = "alarm-${var.env}-${var.project_name}-cluster-CPUReservation-Low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.cluster_instance_scale_down.arn}", "${aws_sns_topic.cw-alert.arn}"]
  ok_actions    = ["${aws_sns_topic.cw-alert.arn}"]
  depends_on    = ["aws_cloudwatch_metric_alarm.cluster_instance_low_cpu"]
}

resource "aws_cloudwatch_metric_alarm" "cluster_instance_high_mem" {
  alarm_name          = "alarm-${var.env}-${var.project_name}-cluster-MemoryReservation-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.cluster_instance_scale_up.arn}", "${aws_sns_topic.cw-alert.arn}"]
  ok_actions    = ["${aws_sns_topic.cw-alert.arn}"]
  depends_on    = ["aws_cloudwatch_metric_alarm.cluster_instance_high_mem"]
}

resource "aws_cloudwatch_metric_alarm" "cluster_instance_low_mem" {
  alarm_name          = "alarm-${var.env}-${var.project_name}-cluster-MemoryReservation-Low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.cluster_instance_scale_down.arn}", "${aws_sns_topic.cw-alert.arn}"]
  ok_actions    = ["${aws_sns_topic.cw-alert.arn}"]
  depends_on    = ["aws_cloudwatch_metric_alarm.cluster_instance_low_mem"]
}

#########################################
# ECS Cluster Scaling Policy
#########################################
resource "aws_autoscaling_policy" "cluster_instance_scale_up" {
  name                   = "asg-${var.env}-${var.project_name}-ScalingPolicyClusterScaleUp"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = "${aws_autoscaling_group.ecs_cluster.name}"
}

resource "aws_autoscaling_policy" "cluster_instance_scale_down" {
  name                   = "asg-${var.env}-${var.project_name}-ScalingPolicyClusterScaleDown"
  scaling_adjustment     = -2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = "${aws_autoscaling_group.ecs_cluster.name}"
}

#########################################
# ECS Service Scaling Policy
#########################################
resource "aws_appautoscaling_target" "nginx_target" {
  depends_on         = ["aws_ecs_cluster.cluster", "aws_ecs_service.service-nginx"]
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.service-nginx.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 2
  max_capacity       = 30
}

resource "aws_appautoscaling_policy" "nginx_scale_cpu" {
  depends_on         = ["aws_ecs_cluster.cluster", "aws_ecs_service.service-nginx", "aws_appautoscaling_target.nginx_target"]
  name               = "ECSServiceAverageCPUUtilization:${aws_appautoscaling_target.nginx_target.resource_id}"
  resource_id        = "${aws_appautoscaling_target.nginx_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.nginx_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.nginx_target.service_namespace}"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 70
    scale_in_cooldown  = 60
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "nginx_scale_memory" {
  depends_on         = ["aws_ecs_cluster.cluster", "aws_ecs_service.service-nginx", "aws_appautoscaling_target.nginx_target"]
  name               = "ECSServiceAverageMemoryUtilization:${aws_appautoscaling_target.nginx_target.resource_id}"
  resource_id        = "${aws_appautoscaling_target.nginx_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.nginx_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.nginx_target.service_namespace}"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 70
    scale_in_cooldown  = 60
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "nginx_scale_count" {
  depends_on         = ["aws_ecs_cluster.cluster", "aws_ecs_service.service-nginx", "aws_appautoscaling_target.nginx_target"]
  name               = "ALBRequestCountPerTarget:${aws_appautoscaling_target.nginx_target.resource_id}"
  resource_id        = "${aws_appautoscaling_target.nginx_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.nginx_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.nginx_target.service_namespace}"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
    }

    target_value       = 100
    scale_in_cooldown  = 60
    scale_out_cooldown = 300
  }
}
