#==============================================================
# Public / variables.tf
#==============================================================

#--------------------------------------------------------------
# Jumpbox config
#--------------------------------------------------------------

variable "enable_jumpbox" {
  description = "Launches a jumpbox at startup"
  default     = false
}

variable "jumpbox_ami" {
  description = "AMI to be used for jumpbox"
}

variable "jump_instance_type" {
  description = "Instance type to be used for jumpbox"
  default     = "t2.nano"
}

variable "ssh_ip_address" {}

#--------------------------------------------------------------
# Network config
#--------------------------------------------------------------

variable "public_subnets" {
  description = "List of public subnets"
  type        = "list"
}

variable "public_route_table_ids" {
  description = "List of route tables assigned to public subnets"
  type        = "list"
}

variable "private_subnet_cidrs" {
  type        = "list"
  description = "List of private cidrs"
}

variable "private_route_table_ids" {
  description = "List of route tables assigned to private subnets"
  type        = "list"
}

variable "destination_cidr_block" {
  description = "Specify all traffic to be routed either through Internet Gateway or NAT to access the internet"
  default     = "0.0.0.0/0"
}

variable "vpc_igw_id" {
  description = "VPC internet gateway id"
}

variable "availability_zones" {
  description = "List of availability zones you want. Example: ap-southeast-2a, ap-southeast-2b"
  type        = "list"
}

variable "enable_nat" {
  default = false
}

variable "enable_gateways" {
  default = false
}

#--------------------------------------------------------------
# Common Settings
#--------------------------------------------------------------

variable "vpc_id" {}

variable "key_name" {}

#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------

variable "cluster" {}

variable "workspace" {}

variable "owner" {}
