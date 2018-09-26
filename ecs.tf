resource "aws_ecr_repository" "nginx" {
  name = "${var.env}-${var.project_name}-repo-nginx"
}

#########################################
# cloudwatch logs group
#########################################
resource "aws_cloudwatch_log_group" "nginx-log" {
  name = "${var.env}-${var.project_name}-nginx-log"
}

########################################
# ECS Cluster
#########################################
resource "aws_ecs_cluster" "cluster" {
  name = "${var.env}-${var.project_name}-cluster"
}

#########################################
# Task Definition
#########################################
data "template_file" "task_definition_nginx" {
  template = "${file("${path.module}/ecs_tasks/task-definition-nginx.json.tpl")}"

  vars {
    name           = "${lookup(var.container-nginx, "name")}"
    image          = "${aws_ecr_repository.nginx.repository_url}"
    version        = "${lookup(var.container-nginx, "version")}"
    memory         = "${lookup(var.container-nginx, "memory")}"
    cpu            = "${lookup(var.container-nginx, "cpu")}"
    docker_port    = "${lookup(var.container-nginx, "docker_port")}"
    awslogs-group  = "${var.env}-${var.project_name}-nginx-log"
    awslogs-region = "${var.region}"
  }
}

resource "aws_ecs_task_definition" "ecs_task_nginx" {
  depends_on            = ["data.template_file.task_definition_nginx"]
  family                = "${var.env}-${var.project_name}-ecs-task-nginx"
  container_definitions = "${data.template_file.task_definition_nginx.rendered}"
  task_role_arn         = "${aws_iam_role.ecs_task_role.arn}"
}

#########################################
# ECS Service
#########################################
resource "aws_ecs_service" "service-nginx" {
  depends_on                         = ["aws_ecs_task_definition.ecs_task_nginx"]
  name                               = "${var.env}-${var.project_name}-service-nginx"
  cluster                            = "${aws_ecs_cluster.cluster.id}"
  task_definition                    = "${aws_ecs_task_definition.ecs_task_nginx.arn}"
  desired_count                      = "${lookup(var.container-nginx, "desired_count")}"
  deployment_maximum_percent         = "${lookup(var.container-nginx, "deployment_maximum_percent")}"
  deployment_minimum_healthy_percent = "${lookup(var.container-nginx, "deployment_minimum_healthy_percent")}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.nginx.arn}"
    container_name   = "${lookup(var.container-nginx, "name")}"
    container_port   = "${lookup(var.container-nginx, "docker_port")}"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

#########################################
# AutoScaling Launch Configuration
#########################################
data "template_file" "ecs_userdata" {
  template = "${file("${path.module}/user_data/ecs_userdata.tpl")}"

  vars {
    cluster_name     = "${aws_ecs_cluster.cluster.name}"
    newrelic_license = "${aws_ssm_parameter.newrelic.value}"
  }
}

resource "aws_launch_configuration" "ecs_cluster" {
  name_prefix                 = "${var.env}-${var.project_name}-cluster-conf-"
  instance_type               = "${lookup(var.ecs, "instance_type")}"
  image_id                    = "${data.aws_ami.ecs_amazon_linux.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.container_instance.name}"
  associate_public_ip_address = "false"
  security_groups             = ["${aws_security_group.app-sg.id}"]
  user_data                   = "${data.template_file.ecs_userdata.rendered}"
  key_name                    = "${var.project_name}-${var.env}-${var.region}"

  lifecycle {
    create_before_destroy = true
  }
}

#########################################
# AutoScaling Group
#########################################
resource "aws_autoscaling_group" "ecs_cluster" {
  name                 = "${var.env}-${var.project_name}-cluster"
  vpc_zone_identifier  = ["${lookup(var.vpc, "app-a")}", "${lookup(var.vpc, "app-c")}"]
  min_size             = "${lookup(var.ecs, "min_size")}"
  max_size             = "${lookup(var.ecs, "max_size")}"
  desired_capacity     = "${lookup(var.ecs, "desired_capacity")}"
  launch_configuration = "${aws_launch_configuration.ecs_cluster.name}"
  health_check_type    = "${lookup(var.ecs, "health_check_type")}"
  target_group_arns    = ["${aws_alb_target_group.nginx.arn}"]

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.project_name}-ecs-host"
    propagate_at_launch = true
  }

  tag {
    key                 = "env"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
