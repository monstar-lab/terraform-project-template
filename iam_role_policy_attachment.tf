#########################################
# IAM Role Attachment for RDS Monitoring
#########################################
resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = "${aws_iam_role.rds_enhanced_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

#########################################
# IAM Role Attachment for bastion
#########################################
resource "aws_iam_role_policy_attachment" "bastion_service_role1" {
  role       = "${aws_iam_role.bastion_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "bastion_service_role2" {
  role       = "${aws_iam_role.bastion_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "bastion_service_role3" {
  role       = "${aws_iam_role.bastion_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "bastion_service_role4" {
  role       = "${aws_iam_role.bastion_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess"
}

resource "aws_iam_role_policy_attachment" "bastion_service_role5" {
  role       = "${aws_iam_role.bastion_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonInspectorFullAccess"
}

#########################################
# IAM Role Attachment for app
#########################################
resource "aws_iam_role_policy_attachment" "app_service_role1" {
  role       = "${aws_iam_role.app_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "app_service_role2" {
  role       = "${aws_iam_role.app_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "app_service_role3" {
  role       = "${aws_iam_role.app_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "app_service_role4" {
  role       = "${aws_iam_role.app_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess"
}

resource "aws_iam_role_policy_attachment" "app_service_role5" {
  role       = "${aws_iam_role.app_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonInspectorFullAccess"
}

#########################################
# IAM Role Attachment for container
#########################################
resource "aws_iam_role_policy_attachment" "container_service_role1" {
  role       = "${aws_iam_role.container_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "container_service_role2" {
  role       = "${aws_iam_role.container_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

#########################################
# IAM Role Attachment for ecs-task
#########################################
resource "aws_iam_role_policy_attachment" "ecs_task_role_attach1" {
  role       = "${aws_iam_role.ecs_task_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_attach2" {
  role       = "${aws_iam_role.ecs_task_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess"
}

#########################################
# IAM Role Attachment for ecs-service-as
#########################################
resource "aws_iam_role_policy_attachment" "ecs_service_autoscaling_role" {
  role       = "${aws_iam_role.ecs_autoscale_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

#########################################
# IAM Role Attachment for ecs-event
#########################################
resource "aws_iam_role_policy_attachment" "ecs_event_role" {
  role       = "${aws_iam_role.ecs_evnet_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

#########################################
# IAM Role Attachment for lambda
#########################################
resource "aws_iam_role_policy_attachment" "lambda_exe_attachment" {
  role       = "${aws_iam_role.lambda_exe_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}
