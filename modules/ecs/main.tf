module "network" {
  source = "../network"

  environment          = "${var.environment}"
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  availability_zones   = "${var.availability_zones}"
  owner                = "${var.owner}"
  cluster              = "${var.cluster}"
  depends_id           = ""
}

module "jumpbox" {
  source = "../jumpbox"

  cluster_name      = "${var.cluster}"
  ssh_ip_address    = "${var.ssh_ip_address}"
  vpc_id            = "${module.network.vpc_id}"
  environment       = "${var.environment}"
  enable_jumpbox    = "${var.enable_jumpbox}"
  owner             = "${var.owner}"
  key_name          = "${var.key_name}"
  public_subnet_ids = "${module.network.public_subnet_ids}"

  jumpbox_ami = "${var.jumpbox_ami}"
}

module "rds" {
  source = "../rds"

  cluster_name       = "${var.cluster}"
  environment        = "${var.environment}"
  vpc_id             = "${module.network.vpc_id}"
  ecs_instance_sg_id = "${module.ecs_instances.ecs_instance_security_group_id}"
  jump_ssh_sg_id     = "${module.jumpbox.jump_ssh_sg_id}"
  availability_zones = "${var.availability_zones}"
  owner              = "${var.owner}"

  db_admin_username = "${var.db_admin_username}"
  db_admin_password = "${var.db_admin_password}"
}

module "ecs_instances" {
  source = "../ecs_instances"

  environment             = "${var.environment}"
  cluster                 = "${var.cluster}"
  instance_group          = "${var.instance_group}"
  private_subnet_ids      = "${module.network.private_subnet_ids}"
  aws_ami                 = "${var.ecs_aws_ami}"
  instance_type           = "${var.instance_type}"
  max_size                = "${var.max_size}"
  min_size                = "${var.min_size}"
  desired_capacity        = "${var.desired_capacity}"
  vpc_id                  = "${module.network.vpc_id}"
  iam_instance_profile_id = "${aws_iam_instance_profile.ecs.id}"
  key_name                = "${var.key_name}"
  load_balancers          = "${var.load_balancers}"
  depends_id              = "${module.network.depends_id}"
  custom_userdata         = "${var.custom_userdata}"
  cloudwatch_prefix       = "${var.cloudwatch_prefix}"
  owner                   = "${var.owner}"
  jump_ssh_sg_id          = "${module.jumpbox.jump_ssh_sg_id}"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster}"
}
