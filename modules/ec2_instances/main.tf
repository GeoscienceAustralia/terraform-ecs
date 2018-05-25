#==============================================================
# ec2_instances / main.tf
#==============================================================

# Sets up the instance configuration on per instance and scaling group basis.

# You can have multiple ECS clusters in the same account with different resources.
# Therefore all resources created here have the name containing the name of the:
# workspace, cluster name and the instance_group name.
# That is also the reason why ecs_instances is a seperate module and not everything is created here.

resource "aws_security_group" "alb" {
  name   = "${var.cluster}_shared_alb_sg"
  vpc_id = "${var.vpc_id}"

  tags {
    workspace  = "${var.workspace}"
    Cluster    = "${var.cluster}"
    Created_by = "terraform"
    Owner      = "${var.owner}"
  }
}

resource "aws_security_group_rule" "http_from_anywhere" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "https_from_anywhere" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group" "instance" {
  name        = "${var.workspace}_${var.cluster}_${var.instance_group}"
  description = "Used in ${var.workspace}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${var.jump_ssh_sg_id}"]
  }

  # ECS dynamically assigns ports in the ephemeral range
  ingress {
    from_port       = 32768
    to_port         = 65535
    protocol        = "TCP"
    security_groups = ["${aws_security_group.alb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name          = "ecs_instance_sg"
    Workspace     = "${var.workspace}"
    Cluster       = "${var.cluster}"
    InstanceGroup = "${var.instance_group}"
    Owner         = "${var.owner}"
    Created_by    = "terraform"
  }
}

# Default disk size for Docker is 22 gig, see http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
resource "aws_launch_configuration" "launch" {
  name_prefix          = "${var.workspace}_${var.cluster}_${var.instance_group}_"
  image_id             = "${var.aws_ami}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.instance.id}"]
  user_data            = "${local.final_user_data}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.id}"
  key_name             = "${var.key_name}"

  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created 
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }
}

# Instances are scaled across availability zones http://docs.aws.amazon.com/autoscaling/latest/userguide/auto-scaling-benefits.html 
# Do not use the load_balancers parameters here as it will overwrite service lbs from registering with the asg
resource "aws_autoscaling_group" "asg" {
  name                 = "${aws_launch_configuration.launch.name}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.launch.id}"
  vpc_zone_identifier  = ["${var.private_subnets}"]

  tag {
    key                 = "Name"
    value               = "${var.workspace}_ecs_${var.cluster}_${var.instance_group}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Workspace"
    value               = "${var.workspace}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = "${var.cluster}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Instance_group"
    value               = "${var.instance_group}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "${var.owner}"
    propagate_at_launch = true
  }

  # EC2 instances require internet connectivity to boot. Thus EC2 instances must not start before NAT is available.
  # For info why see description in the network module.
  tag {
    key                 = "Depends_id"
    value               = "${var.depends_id}"
    propagate_at_launch = false
  }

  tag {
    key                 = "Created_by"
    value               = "terraform"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true

    # Our lambda will adjust this automatically
    ignore_changes = ["desired_capacity"]
  }
}

locals {
  final_user_data = <<EOF
${data.template_file.user_data.rendered}
${var.use_efs == 1 ? data.template_file.efs_user_data.rendered : ""}
  EOF
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh")}"

  vars {
    ecs_config        = "${var.ecs_config}"
    ecs_logging       = "${var.ecs_logging}"
    cluster_name      = "${var.cluster}"
    env_name          = "${var.workspace}"
    custom_userdata   = "${var.custom_userdata}"
    cloudwatch_prefix = "${var.cloudwatch_prefix}"
    aws_region        = "${var.aws_region}"
  }
}

# Even if we are not using EFS, this template
# must exist for our conditionals to evaulate properly
data "template_file" "efs_user_data" {
  template = "sudo mkdir -p $${mount_dir} && sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $${efs_id}.efs.$${aws_region}.amazonaws.com:/ $${mount_dir}"

  vars {
    efs_id     = "${var.efs_id}"
    aws_region = "${var.aws_region}"
    mount_dir  = "${var.mount_dir}"
  }
}
