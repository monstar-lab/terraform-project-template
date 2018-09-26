resource "aws_ssm_parameter" "dbhost" {
  name  = "${var.env}.db_host"
  type  = "String"
  value = "${aws_db_instance.mysql-master.address}"

  tags {
    env = "${var.env}"
  }
}

resource "aws_ssm_parameter" "dbuser" {
  name  = "${var.env}.db_user"
  type  = "String"
  value = "${lookup(var.rds, "database_username")}"

  tags {
    env = "${var.env}"
  }
}

resource "aws_ssm_parameter" "dbpwd" {
  name  = "${var.env}.db_password"
  type  = "SecureString"
  value = "${lookup(var.rds, "database_password")}"

  tags {
    env = "${var.env}"
  }
}

resource "aws_ssm_parameter" "dbname" {
  name  = "${var.env}.db_name"
  type  = "String"
  value = "${lookup(var.rds, "database_name")}"

  tags {
    env = "${var.env}"
  }
}

resource "aws_ssm_parameter" "newrelic" {
  name  = "${var.env}.newrelic_license"
  type  = "SecureString"
  value = "${var.newrelic_license}"
}
