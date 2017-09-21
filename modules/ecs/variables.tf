variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  description = "The name of the ECS cluster"
  default     = "default"
}

variable "instance_group" {
  description = "The name of the instances that you consider as a group"
  default     = "default"
}

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

variable "load_balancers" {
  description = "The load balancers to couple to the instances"
  type        = "list"
  default     = []
}

variable "availability_zones" {
  description = "List of availability zones you want. Example: ap-southeast-2a, ap-southeast-2b"
  type        = "list"
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

variable "key_name" {
  description = "SSH key name to be used"
}

variable "instance_type" {
  description = "AWS instance type to use"
}

variable "ecs_aws_ami" {
  description = "The AWS ami id to use for ECS"
}

variable "custom_userdata" {
  description = "Inject extra command in the instance template to be run on boot"
  default     = ""
}

variable "ecs_config" {
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
  default     = "echo '' > /etc/ecs/ecs.config"
}

variable "ecs_logging" {
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
  default     = "[\"json-file\",\"awslogs\"]"
}

variable "cloudwatch_prefix" {
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
  default     = ""
}

variable "owner" {
  description = "Mailing list for owners"
}

variable "enable_jumpbox" {
  description = "Boolean which enables the jumpbox"
}

variable "jumpbox_ami" {
  description = "ami for the jumpbox"
}

variable "ssh_ip_address" {
  description = "enables ssh access from specified ip address"
}

variable "db_admin_username" {
  description = "the admin username for the RDS instance"
}

variable "db_admin_password" {
  description = "the admin password for the RDS instance"
}
