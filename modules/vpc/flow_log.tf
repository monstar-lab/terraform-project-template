#########################################
# VPC Flow Logs
#########################################
resource "aws_flow_log" "log" {
  log_group_name = "${var.env}-${var.project_name}-flowlog"
  iam_role_arn   = "${aws_iam_role.vpc-flow-role.arn}"
  vpc_id         = "${aws_vpc.vpc.id}"
  traffic_type   = "ALL"
}

#########################################
# IAM Role for VPC Flow Logs
#########################################
resource "aws_iam_role" "vpc-flow-role" {
  name = "${var.env}-${var.project_name}-flowlog-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#########################################
# IAM Role Rolicy for VPC Flow Logs
#########################################
resource "aws_iam_role_policy" "vpc-flow-policy" {
  name = "${var.env}-${var.project_name}-flowlog-policy"
  role = "${aws_iam_role.vpc-flow-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
