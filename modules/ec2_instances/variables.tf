#==============================================================
# ec2_instances / variables.tf
#==============================================================

variable "vpc_id" {
  description = "The VPC id"
}

variable "aws_region" {
  description = "AWS Region we are running in"
  default     = "ap-southeast-2"
}

#--------------------------------------------------------------
# Network Settings
#--------------------------------------------------------------

variable "availability_zones" {
  description = "List of availability zones you want. Example: ap-southeast-2a, ap-southeast-2b"
  type        = "list"
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = "list"
}

variable "private_route_table_ids" {
  description = "List of private route table ids"
  type        = "list"
}

variable "destination_cidr_block" {
  description = "Specify all traffic to be routed either through Internet Gateway or NAT to access the internet"
  default     = "0.0.0.0/0"
}

variable "nat_ids" {
  description = "List of nat ids"
  type        = "list"
}

variable "nat_instance_ids" {
  type        = "list"
  description = "List of EC2 NAT instance IDs"
}

variable "enable_nat" {
  default = false
}

variable "enable_gateways" {
  default = false
}

#--------------------------------------------------------------
# EC2 Instance Settings
#--------------------------------------------------------------

variable "ecs_config" {
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
  default     = "echo '' > /etc/ecs/ecs.config"
}

variable "custom_userdata" {
  description = "Inject extra command in the instance template to be run on boot"
  default     = ""
}

variable "aws_ami" {
  description = "The AWS ami id to use"
}

variable "instance_type" {
  description = "AWS instance type to use"
  default     = "t2.micro"
}

variable "max_size" {
  description = "Maximum size of the nodes in the cluster"
  default     = 1
}

variable "min_size" {
  description = "Minimum size of the nodes in the cluster"
  default     = 1
}

#For more explenation see http://docs.aws.amazon.com/autoscaling/latest/userguide/WhatIsAutoScaling.html
variable "desired_capacity" {
  description = "The desired capacity of the cluster"
  default     = 1
}

variable "instance_group" {
  description = "The name of the instances that you consider as a group"
  default     = "default"
}

variable "depends_id" {
  description = "Workaround to wait for the NAT gateway to finish before starting the instances"
}

#--------------------------------------------------------------
# SSH settings
#--------------------------------------------------------------

variable "key_name" {
  description = "SSH key name to be used"
}

variable "jump_ssh_sg_id" {
  description = "jumpbox security group to allow access to the container runners"
  default     = ""
}

#--------------------------------------------------------------
# Logging
#--------------------------------------------------------------

variable "ecs_logging" {
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
  default     = "[\"json-file\",\"awslogs\"]"
}

variable "cloudwatch_prefix" {
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
  default     = ""
}

variable "container_port" {
  description = "The port that the ecs communicates with the alb"
}

variable "alb_security_group_id" {
  type        = "list"
  description = "The security group of the alb"
}

#--------------------------------------------------------------
# EFS
#--------------------------------------------------------------

variable "efs_id" {
  type    = "string"
  default = ""
}

variable "use_efs" {
  default = true
}

variable "mount_dir" {
  default     = "/opt/data"
  description = "Directory on EC2 where EFS will be mounted."
}

#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------

variable "owner" {}

variable "cluster" {
  description = "The name of the cluster"
}

variable "workspace" {
  description = "The name of the workspace"
}
