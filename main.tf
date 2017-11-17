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

resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster}"
}

module "vpc" {
  source = "modules/components/vpc"

  cidr = "${var.vpc_cidr}"

  # Tags
  workspace = "${var.workspace}"
  owner     = "${var.owner}"
  cluster   = "${var.cluster}"
}

module "public" {
  source = "modules/public_layer"

  # Networking
  vpc_id              = "${module.vpc.id}"
  vpc_igw_id          = "${module.vpc.igw_id}"
  availability_zones  = "${var.availability_zones}"
  public_subnet_cidrs = "${var.public_subnet_cidrs}"
  public_subnet_count = "${length(var.public_subnet_cidrs)}"

  # Jumpbox
  ssh_ip_address = "${var.ssh_ip_address}"
  key_name       = "${var.key_name}"
  jumpbox_ami    = "${data.aws_ami.jumpbox_ami.image_id}"
  enable_jumpbox = "${var.enable_jumpbox}"

  # Tags
  owner     = "${var.owner}"
  cluster   = "${var.cluster}"
  workspace = "${var.workspace}"
}

module "database" {
  source = "modules/database_layer"

  # Networking
  vpc_id             = "${module.vpc.id}"
  availability_zones = "${var.availability_zones}"
  ecs_instance_sg_id = "${module.ec2_instances.ecs_instance_security_group_id}"
  jump_ssh_sg_id     = "${module.public.jump_ssh_sg_id}"

  # DB params
  db_admin_username = "${var.db_admin_username}"
  db_admin_password = "${var.db_admin_password}"

  # Tags
  owner     = "${var.owner}"
  cluster   = "${var.cluster}"
  workspace = "${var.workspace}"
}

module "ec2_instances" {
  source = "modules/ec2_instances"

  # EC2 Parameters
  instance_group    = "${var.instance_group}"
  instance_type     = "${var.instance_type}"
  max_size          = "${var.max_size}"
  min_size          = "${var.min_size}"
  desired_capacity  = "${var.desired_capacity}"
  custom_userdata   = "${var.custom_userdata}"
  cloudwatch_prefix = "${var.cloudwatch_prefix}"
  aws_ami           = "${var.ecs_aws_ami}"

  # Networking
  vpc_id               = "${module.vpc.id}"
  key_name             = "${var.key_name}"
  jump_ssh_sg_id       = "${module.public.jump_ssh_sg_id}"
  nat_ids              = "${module.public.nat_ids}"
  availability_zones   = "${var.availability_zones}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"

  # Force dependency wait
  depends_id = "${module.public.nat_complete}"

  # Tags
  owner     = "${var.owner}"
  cluster   = "${var.cluster}"
  workspace = "${var.workspace}"
}
