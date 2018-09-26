###################################
# S3 bucket for static
###################################
resource "aws_s3_bucket" "static" {
  bucket = "${var.region}-${var.env}-${var.project_name}-${lookup(var.s3, "static_bucket_name")}"
  acl    = "private"

  tags {
    type = "static"
    env  = "${var.env}"
  }
}

###################################
# S3 bucket for alb-logs
###################################
resource "aws_s3_bucket" "alb-logs" {
  bucket = "${var.region}-${var.env}-${var.project_name}-${lookup(var.s3, "alb_log_bucket_name")}"
  acl    = "private"

  tags {
    type = "alblogs"
    env  = "${var.env}"
  }
}

###################################
# S3 bucket for cf-logs
###################################
resource "aws_s3_bucket" "cf-logs" {
  bucket = "${var.region}-${var.env}-${var.project_name}-${lookup(var.s3, "cf_log_bucket_name")}"
  acl    = "private"

  tags {
    type = "cflogs"
    env  = "${var.env}"
  }
}
