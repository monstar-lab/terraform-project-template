terraform {
  required_version = ">= 0.11"
  backend          "s3"             {}
}

provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=master"
  namespace             = "${var.project_name}"
  stage                 = "${var.env}"
  name                  = "${var.region}"
  ssh_public_key_path   = "./secrets"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
  chmod_command         = "chmod 400 %v"
}

module "vpc" {
  source                              = "../../../modules/vpc/prod"
  project_name                        = "${var.project_name}"
  env                                 = "${var.env}"
  availability_zone                   = "${var.availability_zone}"
  vpc_cidrs                           = "${var.vpc_cidrs}"
  front_subnet_cidrs                  = "${var.front_subnet_cidrs}"
  front_subnet_availability_zones     = "${var.front_subnet_availability_zones}"
  app_subnet_cidrs                    = "${var.app_subnet_cidrs}"
  app_subnet_availability_zones       = "${var.app_subnet_availability_zones}"
  datastore_subnet_cidrs              = "${var.datastore_subnet_cidrs}"
  datastore_subnet_availability_zones = "${var.datastore_subnet_availability_zones}"
  batch_subnet_cidrs                  = "${var.batch_subnet_cidrs}"
  batch_subnet_availability_zones     = "${var.batch_subnet_availability_zones}"
}

module "prod" {
  source                = "../../../"
  project_name          = "${var.project_name}"
  env                   = "${var.env}"
  region                = "${var.region}"
  availability_zone     = "${var.availability_zone}"
  bastion_count         = "${var.bastion_count}"
  bastion_instance_type = "${var.bastion_instance_type}"
  app_count             = "${var.app_count}"
  app_instance_type     = "${var.app_instance_type}"
  ssh-allow-lists       = "${var.ssh-allow-lists}"
  front_subnet_cidrs    = "${var.front_subnet_cidrs}"
  vpc                   = "${module.vpc.vpc}"
  app_subnet_list       = "${module.vpc.app_subnet_list}"
  s3                    = "${var.s3}"
  rds                   = "${var.rds}"
  rds-replica           = "${var.rds-replica}"
  cache                 = "${var.cache}"
  ecs                   = "${var.ecs}"
  container-nginx       = "${var.container-nginx}"
  newrelic_license      = "${var.newrelic_license}"
  cloudfront            = "${var.cloudfront}"
  x-pre-shared-key      = "${var.x-pre-shared-key}"
  alb_certificate_arn   = "${var.alb_certificate_arn}"
  cf_certificate_arn    = "${var.cf_certificate_arn}"
}
