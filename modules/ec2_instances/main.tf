#==============================================================
# ec2_instances / main.tf
#==============================================================

# Sets up the instance configuration on per instance and scaling group basis.

# You can have multiple ECS clusters in the same account with different resources.
# Therefore all resources created here have the name containing the name of the:
# workspace, cluster name and the instance_group name.
# That is also the reason why ecs_instances is a seperate module and not everything is created here.

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

  # Datacube
  ingress {
    from_port       = "${var.container_port}"
    to_port         = "${var.container_port}"
    protocol        = "TCP"
    security_groups = ["${var.alb_security_group_id}"]
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
  user_data            = "${data.template_file.user_data.rendered}"
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
  name                 = "${var.workspace}_${var.cluster}_${var.instance_group}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.launch.id}"
  vpc_zone_identifier  = ["${module.private_subnet.ids}"]

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
  }
}
