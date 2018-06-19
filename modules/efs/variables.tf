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

variable "enable" {
  default = false
}

#--------------------------------------------------------------
# AWS SSM Configuration
#--------------------------------------------------------------

variable "ssm_prefix" {
  description = "If set, saves db parameters to the parameter store with the given prefix"
  default     = ""
}

variable "ssm_overwrite" {
  description = "If true any existing parameters will be overwritten"
  default     = "true"
}

variable "ssm_efs_id_ref" {
  type        = "string"
  description = "SSM name reference to use for EFS ID"
  default     = "efsid"
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
