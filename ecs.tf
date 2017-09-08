terraform {
  required_version = ">= 0.10.0"

  backend "s3" {
    # This is an s3bucket you will need to create in your aws 
    # space
    bucket = "dea-devs-tfstate"

    # The key should be unique to each stack, because we want to
    # have multiple enviornments alongside each other we set
    # this dynamically in the bitbucket-pipelines.yml with the
    # --backend
    key = "ecs-test/"

    region = "ap-southeast-2"

    # This is a DynamoDB table with the Primary Key set to LockID
    dynamodb_table = "terraform"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

module "ecs" {
  source = "modules/ecs"

  environment          = "${var.environment}"
  cluster              = "${var.cluster_name}"
  cloudwatch_prefix    = "${var.cluster_name}-${var.environment}" #See ecs_instances module when to set this and when not!
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  availability_zones   = "${var.availability_zones}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  key_name             = "ecs-cluster"
  instance_type        = "${var.instance_type}"
  ecs_aws_ami          = "${var.ecs_aws_ami}"
  availability_zones   = "${var.availability_zones}"
  ssh_ip_address       = "${var.ssh_ip_address}"
  enable_jumpbox       = "${var.enable_jumpbox}"
  owner                = "${var.owner}"

  db_admin_username = "${var.db_admin_username}"
  db_admin_password = "${var.db_admin_password}"

  jumpbox_ami = "${data.aws_ami.jumpbox_ami.image_id}"
}

variable "cluster_name" {}
variable "vpc_cidr" {}
variable "environment" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "instance_type" {}
variable "ecs_aws_ami" {}
variable "owner" {}
variable "ssh_ip_address" {}
variable "enable_jumpbox" {}

variable "private_subnet_cidrs" {
  type = "list"
}

variable "public_subnet_cidrs" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}

output "ecs_lb_role" {
  value = "${module.ecs.ecs_lb_role}"
}

#--------------------------------------------------------------
# Database parameters
#--------------------------------------------------------------

variable db_admin_username {
  description = "the admin username for the rds instance"
}

variable db_admin_password {
  description = "the admin password for the rds instance"
}

#--------------------------------------------------------------
# Server Images
#--------------------------------------------------------------

data "aws_ami" "jumpbox_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:application"
    values = ["Jumpbox"]
  }

  filter {
    name   = "tag:version"
    values = ["${var.environment}"]
  }
}
