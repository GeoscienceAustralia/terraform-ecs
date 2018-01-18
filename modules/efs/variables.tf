variable "private_subnet_cidrs" {
  type = "list"
}

variable "route_table_ids" {
  type = "list"
}

variable "nat_ids" {
  type = "list"
}

variable "destination_cidr_block" {
  description = "Specify all traffic to be routed either through Internet Gateway or NAT to access the internet"
  default     = "0.0.0.0/0"
}

variable "private_subnet_ids" {
  type = "list"
  description = "IDs of the EC2 private subnets, required for EC2 access to the EFS"
}

variable "availability_zones" {
  description = "List of availability zones you want. Example: ap-southeast-2a, ap-southeast-2b"
  type        = "list"
}

variable "vpc_id" {
  description = "The VPC id"
  type = "string"
}

variable "ecs_instance_security_group_id" {
  description = "ID of the security group for the ec2 instances that require efs access"
  type = "string"
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
