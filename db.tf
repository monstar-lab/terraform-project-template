#########################################
# RDS Parameter Group
#########################################
resource "aws_db_parameter_group" "mysql" {
  name        = "${var.env}-${var.project_name}-mysql-rds-group"
  family      = "${lookup(var.rds, "parameter_mysql_group_family")}"
  description = "${var.env}-${var.project_name}-mysql-rds-group"
}

#########################################
# RDS Subnet Group
#########################################
resource "aws_db_subnet_group" "sg" {
  name        = "${var.env}-${var.project_name}-db-subnet-group"
  description = "${var.env}-${var.project_name}-db-subnet-group"
  subnet_ids  = ["${lookup(var.vpc, "datastore-a")}", "${lookup(var.vpc, "datastore-c")}"]

  tags {
    Name = "${var.env}-${var.project_name}-db-sg"
    env  = "${var.env}"
  }
}

#########################################
# RDS Instance
#########################################
resource "aws_db_instance" "mysql-master" {
  count                           = "${lookup(var.rds, "count")}"
  allocated_storage               = "${lookup(var.rds, "allocated_storage")}"
  engine                          = "mysql"
  engine_version                  = "${lookup(var.rds, "engine_version")}"
  identifier                      = "${var.env}-${var.project_name}-db-master"
  instance_class                  = "${lookup(var.rds, "instance_type")}"
  storage_type                    = "${lookup(var.rds, "storage_type")}"
  name                            = "${lookup(var.rds, "database_name")}"
  password                        = "${lookup(var.rds, "database_password")}"
  username                        = "${lookup(var.rds, "database_username")}"
  backup_retention_period         = "${lookup(var.rds, "backup_retention_period")}"
  backup_window                   = "${lookup(var.rds, "backup_window")}"
  maintenance_window              = "${lookup(var.rds, "maintenance_window")}"
  auto_minor_version_upgrade      = "${lookup(var.rds, "auto_minor_version_upgrade")}"
  final_snapshot_identifier       = "${lookup(var.rds, "final_snapshot_identifier")}"
  skip_final_snapshot             = "${lookup(var.rds, "skip_final_snapshot")}"
  copy_tags_to_snapshot           = "${lookup(var.rds, "copy_tags_to_snapshot")}"
  multi_az                        = "${lookup(var.rds, "multi_availability_zone")}"
  port                            = "${lookup(var.rds, "database_port")}"
  vpc_security_group_ids          = ["${aws_security_group.db-sg.id}"]
  db_subnet_group_name            = "${aws_db_subnet_group.sg.name}"
  parameter_group_name            = "${aws_db_parameter_group.mysql.name}"
  storage_encrypted               = "${lookup(var.rds, "storage_encrypted")}"
  apply_immediately               = "${lookup(var.rds, "apply_immediately")}"
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  monitoring_interval             = "${lookup(var.rds, "monitoring_interval")}"
  monitoring_role_arn             = "${aws_iam_role.rds_enhanced_monitoring.arn}"

  tags {
    env = "${var.env}"
  }
}

#########################################
# RDS Replica Instance
#########################################
resource "aws_db_instance" "mysql-replica-a" {
  count                           = "${lookup(var.rds-replica, "readreplica_count_a")}"
  allocated_storage               = "${lookup(var.rds-replica, "allocated_storage")}"
  availability_zone               = "ap-northeast-1a"
  engine                          = "mysql"
  engine_version                  = "${lookup(var.rds-replica, "engine_version")}"
  identifier                      = "${format("${var.env}-${var.project_name}-db-replica-a-%02d", count.index + 1)}"
  instance_class                  = "${lookup(var.rds-replica, "instance_type")}"
  storage_type                    = "${lookup(var.rds-replica, "storage_type")}"
  name                            = "${lookup(var.rds-replica, "database_name")}"
  backup_retention_period         = "${lookup(var.rds-replica, "backup_retention_period")}"
  backup_window                   = "${lookup(var.rds-replica, "backup_window")}"
  maintenance_window              = "${lookup(var.rds-replica, "maintenance_window")}"
  auto_minor_version_upgrade      = "${lookup(var.rds-replica, "auto_minor_version_upgrade")}"
  final_snapshot_identifier       = "${lookup(var.rds-replica, "final_snapshot_identifier")}"
  skip_final_snapshot             = "${lookup(var.rds-replica, "skip_final_snapshot")}"
  copy_tags_to_snapshot           = "${lookup(var.rds-replica, "copy_tags_to_snapshot")}"
  multi_az                        = "${lookup(var.rds-replica, "multi_availability_zone")}"
  port                            = "${lookup(var.rds-replica, "database_port")}"
  vpc_security_group_ids          = ["${aws_security_group.db-sg.id}"]
  parameter_group_name            = "${aws_db_parameter_group.mysql.name}"
  storage_encrypted               = "${lookup(var.rds-replica, "storage_encrypted")}"
  replicate_source_db             = "${aws_db_instance.mysql-master.identifier}"
  apply_immediately               = "${lookup(var.rds-replica, "apply_immediately")}"
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  monitoring_interval = "${lookup(var.rds-replica, "monitoring_interval")}"
  monitoring_role_arn = "${aws_iam_role.rds_enhanced_monitoring.arn}"

  tags {
    env = "${var.env}"
  }
}

resource "aws_db_instance" "mysql-replica-c" {
  count                           = "${lookup(var.rds-replica, "readreplica_count_c")}"
  allocated_storage               = "${lookup(var.rds-replica, "allocated_storage")}"
  availability_zone               = "ap-northeast-1c"
  engine                          = "mysql"
  engine_version                  = "${lookup(var.rds-replica, "engine_version")}"
  identifier                      = "${format("${var.env}-${var.project_name}-db-replica-c-%02d", count.index + 1)}"
  instance_class                  = "${lookup(var.rds-replica, "instance_type")}"
  storage_type                    = "${lookup(var.rds-replica, "storage_type")}"
  name                            = "${lookup(var.rds-replica, "database_name")}"
  backup_retention_period         = "${lookup(var.rds-replica, "backup_retention_period")}"
  backup_window                   = "${lookup(var.rds-replica, "backup_window")}"
  maintenance_window              = "${lookup(var.rds-replica, "maintenance_window")}"
  auto_minor_version_upgrade      = "${lookup(var.rds-replica, "auto_minor_version_upgrade")}"
  final_snapshot_identifier       = "${lookup(var.rds-replica, "final_snapshot_identifier")}"
  skip_final_snapshot             = "${lookup(var.rds-replica, "skip_final_snapshot")}"
  copy_tags_to_snapshot           = "${lookup(var.rds-replica, "copy_tags_to_snapshot")}"
  multi_az                        = "${lookup(var.rds-replica, "multi_availability_zone")}"
  port                            = "${lookup(var.rds-replica, "database_port")}"
  vpc_security_group_ids          = ["${aws_security_group.db-sg.id}"]
  parameter_group_name            = "${aws_db_parameter_group.mysql.name}"
  storage_encrypted               = "${lookup(var.rds-replica, "storage_encrypted")}"
  replicate_source_db             = "${aws_db_instance.mysql-master.identifier}"
  apply_immediately               = "${lookup(var.rds-replica, "apply_immediately")}"
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  monitoring_interval = "${lookup(var.rds-replica, "monitoring_interval")}"
  monitoring_role_arn = "${aws_iam_role.rds_enhanced_monitoring.arn}"

  tags {
    env = "${var.env}"
  }
}

#########################################
# SNS Topic
#########################################
resource "aws_sns_topic" "db-event" {
  name = "rds-events"
}

#########################################
# RDS Event Subscription
#########################################
resource "aws_db_event_subscription" "db_event_subscription" {
  name      = "${var.env}-${var.project_name}-rds-event-sub"
  sns_topic = "${aws_sns_topic.db-event.arn}"

  source_type = "db-instance"
  source_ids  = ["${aws_db_instance.mysql-master.id}"]

  event_categories = [
    "availability",
    "deletion",
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration",
  ]
}
