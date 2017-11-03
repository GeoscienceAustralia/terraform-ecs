#--------------------------------------------------------------
# Networking
#--------------------------------------------------------------

variable "vpc_cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "List of private cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
  type        = "list"
}

variable "public_subnet_cidrs" {
  description = "List of public cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
  type        = "list"
}

variable "availability_zones" {
  description = "List of availability zones you want. Example: ap-southeast-2a, ap-southeast-2b"
  type        = "list"
}

#--------------------------------------------------------------
# EC2 Configuration
#--------------------------------------------------------------

variable "custom_userdata" {
  description = "Inject extra command in the instance template to be run on boot"
  default     = ""
}

variable "ecs_config" {
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
  default     = "echo '' > /etc/ecs/ecs.config"
}

variable "instance_type" {
  description = "AWS instance type to use"
}

variable "ecs_aws_ami" {
  description = "The AWS ami id to use for ECS"
}

variable "max_size" {
  description = "Maximum size of the nodes in the cluster"
}

variable "min_size" {
  description = "Minimum size of the nodes in the cluster"
}

variable "desired_capacity" {
  description = "The desired capacity of the cluster"
}

variable "instance_group" {
  description = "The name of the instances that you consider as a group"
  default     = "default"
}

#--------------------------------------------------------------
# EC2 Logging
#--------------------------------------------------------------

variable "ecs_logging" {
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
  default     = "[\"json-file\",\"awslogs\"]"
}

variable "cloudwatch_prefix" {
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
  default     = ""
}

#--------------------------------------------------------------
# Jumpbox
#--------------------------------------------------------------

variable "enable_jumpbox" {
  description = "Boolean which enables the jumpbox"
}

variable "ssh_ip_address" {
  description = "enables ssh access from specified ip address"
}

variable "key_name" {
  description = "SSH key name to be used"
}

#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------

variable "owner" {
  description = "Mailing list for owners"
}

variable "workspace" {
  description = "The name of the workspace"
}

variable "cluster" {
  description = "The name of the ECS cluster"
  default     = "default"
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
    values = ["${var.workspace}"]
  }
}
