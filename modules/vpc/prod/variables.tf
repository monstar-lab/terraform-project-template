variable "env" {}
variable "project_name" {}

variable "availability_zone" {
  type = "list"
}

variable "vpc_cidrs" {}

variable "front_subnet_cidrs" {
  type = "list"
}

variable "front_subnet_availability_zones" {
  type = "list"
}

variable "app_subnet_cidrs" {
  type = "list"
}

variable "app_subnet_availability_zones" {
  type = "list"
}

variable "datastore_subnet_cidrs" {
  type = "list"
}

variable "datastore_subnet_availability_zones" {
  type = "list"
}

variable "batch_subnet_cidrs" {
  type = "list"
}

variable "batch_subnet_availability_zones" {
  type = "list"
}
