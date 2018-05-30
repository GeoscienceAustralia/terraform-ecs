variable "aws_region" {
  default = "ap-southeast-2"
}

variable "state_bucket" {
  description = "The s3 bucket used to store terraform state"
}

#--------------------------------------------------------------
# Networking
#--------------------------------------------------------------

variable "vpc_cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
  type        = "list"
}

variable "private_subnet_cidrs" {
  description = "List of private cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
  type        = "list"
}

variable "database_subnet_cidrs" {
  description = "List of database cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
  type        = "list"
}

variable "availability_zones" {
  description = "List of availability zones you want. Example: ap-southeast-2a, ap-southeast-2b"
  type        = "list"
}

# ==================
# DNS and HTTPS

variable "dns_zone" {
  default     = ""
  description = "DNS zone of the service, you will also need a wildcard cert for this domain"
}

variable "ssl_cert_region" {
  default     = "ap-southeast-2"
  description = "The region the certificates exist in"
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

variable "db_dns_name" {
  default     = "database"
  description = "Database url prefix"
}

variable "db_zone" {
  default     = "local"
  description = "Route53 Zone suffix"
}

variable "db_name" {
  default     = "postgres"
  description = "Name of the first database"
}

variable "db_multi_az" {
  default     = false
  description = "Enable redundancy for the DB"
}

#--------------------------------------------------------------
# Server Images
#--------------------------------------------------------------

data "aws_ami" "node_ami" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  owners = ["amazon"]
}

# Use this if you want to customise your jumpbox server image

data "aws_ami" "jumpbox_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#--------------------------------------------------------------
# Account ID
#--------------------------------------------------------------

# Get the AWS account ID so we can use it in IAM policies

data "aws_caller_identity" "current" {}

#--------------------------------------------------------------
# Service Config
#--------------------------------------------------------------

variable "use_ecs_cli_compose" {
  default = true
}

variable "container_port" {
  default = "80"
}

variable "service_name" {
  default = "datacube"
}

variable "service_entrypoint" {
  default = "web"
}

variable "service_compose" {
  default = "docker-compose.yml"
}

variable "max_percent" {
  default     = "600"
  description = "Max percentage of the desired count"
}

variable "timeout" {
  default     = "3"
  description = "time in minutes to wait for a service to become healthy"
}

variable "health_check_path" {
  default     = "/"
  description = "path for load balancer health check"
}

variable "config_root" {
  default     = "https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/prod/"
  description = "The default path to look for config files"
}
