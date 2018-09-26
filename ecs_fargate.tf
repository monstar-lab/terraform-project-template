resource "aws_ecr_repository" "fargete_nginx" {
  name = "${var.env}-${var.project_name}-fargate-repo-nginx"
}

#########################################
# cloudwatch logs group
#########################################
resource "aws_cloudwatch_log_group" "fargete_nginx_log" {
  name = "${var.env}-${var.project_name}-fargate-nginx-log"
}

########################################
# ECS Cluster
#########################################
resource "aws_ecs_cluster" "fargete_cluster" {
  name = "${var.env}-${var.project_name}-fargate-cluster"
}

#########################################
# Task Definition
#########################################
data "template_file" "task_definition_fargete_nginx" {
  template = "${file("${path.module}/ecs_tasks/task-definition-fargete-nginx.json.tpl")}"

  vars {
    name           = "${lookup(var.container-nginx, "name")}"
    image          = "${aws_ecr_repository.fargete_nginx.repository_url}"
    version        = "${lookup(var.container-nginx, "version")}"
    memory         = "${lookup(var.container-nginx, "memory")}"
    cpu            = "${lookup(var.container-nginx, "cpu")}"
    docker_port    = "${lookup(var.container-nginx, "docker_port")}"
    awslogs-group  = "${var.env}-${var.project_name}-fargete-nginx-log"
    awslogs-region = "${var.region}"
  }
}

resource "aws_ecs_task_definition" "ecs_task_fargete_nginx" {
  depends_on            = ["data.template_file.task_definition_fargete_nginx"]
  family                = "${var.env}-${var.project_name}-ecs-task-fargete-nginx"
  container_definitions = "${data.template_file.task_definition_fargete_nginx.rendered}"
  task_role_arn         = "${aws_iam_role.ecs_task_role.arn}"
}

#########################################
# ECS Service
#########################################
resource "aws_ecs_service" "service-fargete-nginx" {
  depends_on                         = ["aws_ecs_task_definition.ecs_task_fargete_nginx"]
  name                               = "${var.env}-${var.project_name}-service-fargete-nginx"
  cluster                            = "${aws_ecs_cluster.fargete_cluster.id}"
  task_definition                    = "${aws_ecs_task_definition.ecs_task_fargete_nginx.arn}"
  desired_count                      = "${lookup(var.container-nginx, "desired_count")}"
  deployment_maximum_percent         = "${lookup(var.container-nginx, "deployment_maximum_percent")}"
  deployment_minimum_healthy_percent = "${lookup(var.container-nginx, "deployment_minimum_healthy_percent")}"
  launch_type                        = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.nginx.arn}"
    container_name   = "${lookup(var.container-nginx, "name")}"
    container_port   = "${lookup(var.container-nginx, "docker_port")}"
  }

  network_configuration {
    security_groups = ["${aws_security_group.app-sg.id}"]
    subnets         = ["${lookup(var.vpc, "app-a")}", "${lookup(var.vpc, "app-c")}"]
  }
}
