data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "bastion_instance_ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "app_instance_ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "container_instance_ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecs_as_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecs_event_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_exe_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

#########################################
# IAM Role for EC2
#########################################
resource "aws_iam_role" "bastion_instance" {
  name               = "${var.env}-${var.project_name}-BastionInstanceProfile"
  assume_role_policy = "${data.aws_iam_policy_document.bastion_instance_ec2_assume_role.json}"
}

resource "aws_iam_instance_profile" "bastion_instance" {
  name = "${aws_iam_role.bastion_instance.name}"
  role = "${aws_iam_role.bastion_instance.name}"
}

resource "aws_iam_role" "app_instance" {
  name               = "${var.env}-${var.project_name}-AppInstanceProfile"
  assume_role_policy = "${data.aws_iam_policy_document.app_instance_ec2_assume_role.json}"
}

resource "aws_iam_instance_profile" "app_instance" {
  name = "${aws_iam_role.app_instance.name}"
  role = "${aws_iam_role.app_instance.name}"
}

resource "aws_iam_role" "container_instance" {
  name               = "${var.env}-${var.project_name}-ContainerInstanceProfile"
  assume_role_policy = "${data.aws_iam_policy_document.container_instance_ec2_assume_role.json}"
}

resource "aws_iam_instance_profile" "container_instance" {
  name = "${aws_iam_role.container_instance.name}"
  role = "${aws_iam_role.container_instance.name}"
}

#########################################
# IAM Role for ECS Task
#########################################
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.env}-${var.project_name}-ecs-task-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_assume_role.json}"
}

#########################################
# IAM Role for ECS AS
#########################################
resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "${var.env}-${var.project_name}-ecsASRole"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_as_assume_role.json}"
}

#########################################
# IAM Role for ECS Event
#########################################
resource "aws_iam_role" "ecs_evnet_role" {
  name               = "${var.env}-${var.project_name}-ecsEventRole"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_event_role.json}"
}

#########################################
# IAM Role for Lambda
#########################################
resource "aws_iam_role" "lambda_exe_role" {
  name_prefix        = "${var.env}-${var.project_name}-LambdaRole"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_exe_assume_role.json}"
}

#########################################
# IAM Role for RDS Monitoring
#########################################
resource "aws_iam_role" "rds_enhanced_monitoring" {
  name               = "${var.env}-${var.project_name}-monitoring-role"
  assume_role_policy = "${data.aws_iam_policy_document.rds_enhanced_monitoring.json}"
}
