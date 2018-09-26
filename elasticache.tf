###################################
# ElastiCache Parameter Group
###################################
resource "aws_elasticache_parameter_group" "pg" {
  name        = "${var.env}-${var.project_name}-cache-parameter-group"
  description = "${var.env}-${var.project_name}-cache-parameter-group"
  family      = "redis4.0"
}

###################################
# ElastiCache Subnet Group
###################################
resource "aws_elasticache_subnet_group" "sg" {
  name        = "${var.env}-${var.project_name}-cache-subnet-group"
  description = "${var.env}-${var.project_name}-cache-subnet-group"
  subnet_ids  = ["${lookup(var.vpc, "datastore-a")}", "${lookup(var.vpc, "datastore-c")}"]
}

###################################
# ElastiCache for Redis
###################################
resource "aws_elasticache_replication_group" "cache" {
  replication_group_id          = "${var.env}-${var.project_name}-cluster"
  replication_group_description = "${var.env}-${var.project_name}-cluster"
  node_type                     = "${lookup(var.cache, "node_type")}"
  port                          = 6379
  parameter_group_name          = "default.redis4.0.cluster.on"
  automatic_failover_enabled    = true
  subnet_group_name             = "${aws_elasticache_subnet_group.sg.name}"
  security_group_ids            = ["${aws_security_group.cache-sg.id}"]
  maintenance_window            = "${lookup(var.cache, "maintenance_window")}"

  cluster_mode {
    replicas_per_node_group = "${lookup(var.cache, "replica_count")}"
    num_node_groups         = "${lookup(var.cache, "number_cache_clusters")}"
  }

  tags {
    Name = "${var.env}-${var.project_name}-cluster"
    env  = "${var.env}"
  }
}
