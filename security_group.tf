###################################
# Security Group for bastion-sg
###################################
resource "aws_security_group" "bastion-sg" {
  count       = "${var.env == "dev" ? 1 : 0}"
  name        = "${var.project_name}-bastion-sg"
  description = "${var.project_name}-bastion-sg"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.project_name}-bastion-sg"
  }
}

resource "aws_security_group_rule" "bastion-sg" {
  count             = "${var.env == "dev" ? 1 : 0}"
  security_group_id = "${aws_security_group.bastion-sg.id}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.ssh-allow-lists}"]
}

###################################
# Security Group for alb-sg
###################################
resource "aws_security_group" "alb-sg" {
  name        = "${var.env}-${var.project_name}-alb-sg"
  description = "${var.env}-${var.project_name}-alb-sg"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env}-${var.project_name}-alb-sg"
    env  = "${var.env}"
  }
}

###################################
# Security Group for app-sg
###################################
resource "aws_security_group" "app-sg" {
  name        = "${var.env}-${var.project_name}-app-sg"
  description = "${var.env}-${var.project_name}-app-sg"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh-allow-lists}"]
  }

  ingress {
    from_port       = 31000
    to_port         = 61000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env}-${var.project_name}-app-sg"
    env  = "${var.env}"
  }
}

###################################
# Security Group for db-sg
###################################
resource "aws_security_group" "db-sg" {
  name        = "${var.env}-${var.project_name}-db-sg"
  description = "${var.env}-${var.project_name}-db-sg"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-sg.id}"]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-sg.id}"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.front_subnet_cidrs[0]}", "${var.front_subnet_cidrs[1]}"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.front_subnet_cidrs[0]}", "${var.front_subnet_cidrs[1]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env}-${var.project_name}-db-sg"
    env  = "${var.env}"
  }
}

###################################
# Security Group for cache-sg
###################################
resource "aws_security_group" "cache-sg" {
  name        = "${var.env}-${var.project_name}-cache-sg"
  description = "${var.env}-${var.project_name}-cache-sg"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-sg.id}"]
  }

  ingress {
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-sg.id}"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${var.front_subnet_cidrs[0]}", "${var.front_subnet_cidrs[1]}"]
  }

  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["${var.front_subnet_cidrs[0]}", "${var.front_subnet_cidrs[1]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env}-${var.project_name}-cache-sg"
    env  = "${var.env}"
  }
}

###################################
# Security Group for cache-sg
###################################
resource "aws_security_group" "batch-sg" {
  name        = "${var.env}-${var.project_name}-batch-sg"
  description = "${var.env}-${var.project_name}-batch-sg"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-sg.id}"]
  }

  ingress {
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env}-${var.project_name}-batch-sg"
    env  = "${var.env}"
  }
}
