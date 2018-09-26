variable "region" {}

variable "env" {}
variable "project_name" {}

variable "availability_zone" {
  type = "list"
}

variable "front_subnet_cidrs" {
  type = "list"
}

variable "newrelic_license" {}

variable "bastion_count" {}
variable "bastion_instance_type" {}

variable "app_count" {}
variable "app_instance_type" {}

variable "ssh-allow-lists" {
  type = "list"
}

variable "vpc" {
  type = "map"
}

variable "app_subnet_list" {
  type = "list"
}

variable "s3" {
  type = "map"
}

variable "rds" {
  type = "map"
}

variable "rds-replica" {
  type = "map"
}

variable "cache" {
  type = "map"
}

variable "ecs" {
  type = "map"
}

variable "container-nginx" {
  type = "map"
}

variable "x-pre-shared-key" {}

variable "alb_certificate_arn" {}
variable "cf_certificate_arn" {}

variable "cloudfront" {
  type = "map"
}
