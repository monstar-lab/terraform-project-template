#########################################
# S3 bucket policy for alb-logs
#########################################
resource "aws_s3_bucket_policy" "alb-logs" {
  bucket     = "${aws_s3_bucket.alb-logs.id}"
  depends_on = ["aws_s3_bucket.alb-logs"]

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "AWSConsole-AccessLogs-Policy-1532309584793",
    "Statement": [
        {
            "Sid": "AWSConsoleStmt-1532309584793",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::582318560864:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.region}-${var.env}-${var.project_name}-${lookup(var.s3, "alb_log_bucket_name")}/*"
        }
    ]
}
POLICY
}
