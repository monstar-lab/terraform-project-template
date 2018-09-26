variable "region" {
  default = "ap-northeast-1"
}

variable "profile" {
  default = "takayuki"
}

variable "env" {
  default = "dev"
}

variable "project_name" {
  default = "demo"
}

variable "availability_zone" {
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "vpc_cidrs" {
  default = "10.2.0.0/16"
}

variable "front_subnet_cidrs" {
  default = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "front_subnet_availability_zones" {
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "app_subnet_cidrs" {
  default = ["10.2.3.0/24", "10.2.4.0/24"]
}

variable "app_subnet_availability_zones" {
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "datastore_subnet_cidrs" {
  default = ["10.2.5.0/24", "10.2.6.0/24"]
}

variable "datastore_subnet_availability_zones" {
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "batch_subnet_cidrs" {
  default = ["10.2.7.0/24", "10.2.8.0/24"]
}

variable "batch_subnet_availability_zones" {
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "newrelic_license" {
  default = "xxxxx"
}

variable "bastion_count" {
  default = "1"
}

variable "bastion_instance_type" {
  default = "t3.micro"
}

variable "app_count" {
  default = "2"
}

variable "app_instance_type" {
  default = "t3.micro"
}

variable "ssh-allow-lists" {
  default = ["14.12.136.96/32"]
}

variable "s3" {
  default = {
    "static_bucket_name"  = "static"
    "alb_log_bucket_name" = "alb-logs"
    "cf_log_bucket_name"  = "cf-logs"
  }
}

variable "rds" {
  default = {
    "count"                        = "1"
    "parameter_mysql_group_family" = "mysql5.7"
    "allocated_storage"            = "100"
    "engine_version"               = "5.7.21"
    "instance_type"                = "db.t2.micro"
    "storage_type"                 = "gp2"
    "database_name"                = "sample"
    "database_username"            = "sampledbmaster"
    "database_password"            = "gZC9s+7?:w2TFWT3}2hm"
    "database_port"                = "3306"
    "backup_retention_period"      = "1"
    "backup_window"                = "09:00-09:30"
    "maintenance_window"           = "sun:19:00-sun:20:00"
    "final_snapshot_identifier"    = "final-db-snapshot"
    "monitoring_interval"          = "60"
    "auto_minor_version_upgrade"   = false
    "multi_availability_zone"      = true
    "storage_encrypted"            = false
    "skip_final_snapshot"          = false
    "copy_tags_to_snapshot"        = true
    "apply_immediately"            = true
  }
}

variable "rds-replica" {
  default = {
    "readreplica_count_a"          = "1"
    "readreplica_count_c"          = "1"
    "parameter_mysql_group_family" = "mysql5.7"
    "allocated_storage"            = "100"
    "engine_version"               = "5.7.21"
    "instance_type"                = "db.t2.micro"
    "storage_type"                 = "gp2"
    "database_name"                = "sample"
    "database_port"                = "3306"
    "backup_retention_period"      = "1"
    "backup_window"                = "09:00-09:30"
    "maintenance_window"           = "sun:19:00-sun:20:00"
    "final_snapshot_identifier"    = "final-db-snapshot"
    "monitoring_interval"          = "60"
    "auto_minor_version_upgrade"   = false
    "multi_availability_zone"      = true
    "storage_encrypted"            = false
    "skip_final_snapshot"          = false
    "copy_tags_to_snapshot"        = true
    "apply_immediately"            = true
  }
}

variable "cache" {
  default = {
    number_cache_clusters   = "1"
    replica_count           = "1"
    engine_name             = "redis"
    engine_version          = "4.0.10"
    node_type               = "cache.m3.medium"
    backup_retention_period = "3"
    backup_window           = "09:00-09:30"
    maintenance_window      = "sun:19:00-sun:20:00"
  }
}

variable "ecs" {
  default = {
    min_size          = "2"
    max_size          = "4"
    desired_capacity  = "2"
    instance_type     = "m5.large"
    health_check_type = "EC2"
  }
}

variable "container-nginx" {
  default = {
    name                               = "nginx"
    docker_port                        = "80"
    version                            = "latest"
    memory                             = "256"
    cpu                                = "128"
    desired_count                      = "2"
    deployment_maximum_percent         = "200"
    deployment_minimum_healthy_percent = "100"
  }
}

variable "cloudfront" {
  default = {
    web_domain_name = "dev-web.sample.com"
    img_domain_name = "dev-img.sample.com"
  }
}

variable "x-pre-shared-key" {
  default = "^RwfhZCb*eC:iA.YdUKX"
}

variable "alb_certificate_arn" {
  default = "arn:aws:acm:ap-northeast-1:xxxxxxx:certificate/xxxxxxxxx"
}

variable "cf_certificate_arn" {
  default = "arn:aws:acm:us-east-1:xxxxxxx:certificate/xxxxxxxxx"
}
