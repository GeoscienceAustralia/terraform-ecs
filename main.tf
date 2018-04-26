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
    key = "datacube-ecs-test/"

    region = "ap-southeast-2"

    # This is a DynamoDB table with the Primary Key set to LockID
    dynamodb_table = "terraform"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster}"
}

module "vpc" {
  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.30.0
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.30.0"

  name = "${var.cluster}-vpc"
  cidr = "${var.vpc_cidr}"

  azs              = "${var.availability_zones}"
  public_subnets   = "${var.public_subnet_cidrs}"
  private_subnets  = "${var.private_subnet_cidrs}"
  database_subnets = "${var.database_subnet_cidrs}"

  # Use nat instances instead
  enable_nat_gateway           = false
  create_database_subnet_group = true
  enable_s3_endpoint           = true

  tags = {
    workspace  = "${var.workspace}"
    owner      = "${var.owner}"
    cluster    = "${var.cluster}"
    Created_by = "terraform"
  }
}

module "public" {
  source = "modules/public_layer"

  # Networking
  vpc_id                  = "${module.vpc.vpc_id}"
  vpc_igw_id              = "${module.vpc.igw_id}"
  availability_zones      = "${var.availability_zones}"
  public_subnets          = "${module.vpc.public_subnets}"
  public_route_table_ids  = "${module.vpc.public_route_table_ids}"
  private_subnet_cidrs    = "${var.private_subnet_cidrs}"
  private_route_table_ids = "${module.vpc.private_route_table_ids}"

  # Jumpbox
  ssh_ip_address = "${var.ssh_ip_address}"
  key_name       = "${var.key_name}"
  jumpbox_ami    = "${data.aws_ami.jumpbox_ami.image_id}"
  enable_jumpbox = "${var.enable_jumpbox}"
  enable_nat     = true

  # Tags
  owner     = "${var.owner}"
  cluster   = "${var.cluster}"
  workspace = "${var.workspace}"
}

module "database" {
  source = "modules/database_layer"

  # Networking
  vpc_id                = "${module.vpc.vpc_id}"
  ecs_instance_sg_id    = "${module.ec2_instances.ecs_instance_security_group_id}"
  jump_ssh_sg_id        = "${module.public.jump_ssh_sg_id}"
  database_subnet_group = "${module.vpc.database_subnet_group}"

  # DB params
  db_admin_username = "${var.db_admin_username}"
  db_admin_password = "${var.db_admin_password}"
  dns_name          = "${var.db_dns_name}"
  zone              = "${var.db_zone}"
  db_name           = "${var.db_name}"
  rds_is_multi_az   = "${var.db_multi_az}"
  ssm_prefix        = "${var.cluster}"

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
  cloudwatch_prefix = "${var.cluster}"
  aws_ami           = "${var.ecs_aws_ami}"

  # Networking
  vpc_id                  = "${module.vpc.vpc_id}"
  key_name                = "${var.key_name}"
  jump_ssh_sg_id          = "${module.public.jump_ssh_sg_id}"
  nat_ids                 = "${module.public.nat_ids}"
  nat_instance_ids        = "${module.public.nat_instance_ids}"
  availability_zones      = "${var.availability_zones}"
  private_subnets         = "${module.vpc.private_subnets}"
  private_route_table_ids = "${module.vpc.private_route_table_ids}"
  container_port          = "${var.container_port}"

  # Force dependency wait
  depends_id = "${module.public.nat_complete}"

  # Tags
  owner     = "${var.owner}"
  cluster   = "${var.cluster}"
  workspace = "${var.workspace}"

  aws_region = "${var.aws_region}"
}
