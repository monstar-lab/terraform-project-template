###################################
# alb (target group add attachment)
###################################
resource "aws_alb_target_group" "nginx" {
  name                 = "${var.env}-${var.project_name}-nginx-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${lookup(var.vpc, "vpc_id")}"
  deregistration_delay = 30

  health_check {
    interval            = 30
    path                = "/nginx_status"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags {
    Name = "${var.env}-${var.project_name}-nginx-tg"
    env  = "${var.env}"
  }
}

###################################
# alb
###################################
resource "aws_alb" "nginx" {
  name                       = "${var.env}-${var.project_name}-alb"
  subnets                    = ["${lookup(var.vpc, "front-a")}", "${lookup(var.vpc, "front-c")}"]
  security_groups            = ["${aws_security_group.alb-sg.id}"]
  internal                   = false
  enable_deletion_protection = false

  access_logs {
    enabled = true
    bucket  = "${aws_s3_bucket.alb-logs.bucket}"
    prefix  = "nginx"
  }

  tags {
    Name = "${var.env}-${var.project_name}-alb"
    env  = "${var.env}"
  }
}

###################################
# alb (listen add target group 80)
###################################
resource "aws_alb_listener" "nginx-alb-insecure-listener" {
  load_balancer_arn = "${aws_alb.nginx.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.nginx.arn}"
    type             = "forward"
  }
}

##################################
# alb (listen add target group 443)
###################################
# resource "aws_alb_listener" "nginx-alb-secure-listener" {
#   load_balancer_arn = "${aws_alb.nginx.arn}"
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "${var.alb_certificate_arn}"

#   default_action {
#     target_group_arn = "${aws_alb_target_group.nginx.arn}"
#     type             = "forward"
#   }
# }

###################################
# alb (listen rule)
###################################
resource "aws_alb_listener_rule" "nginx-alb-listener-rule" {
  listener_arn = "${aws_alb_listener.nginx-alb-insecure-listener.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.nginx.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/"]
  }
}
