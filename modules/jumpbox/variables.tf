#==============================================================
# Jumpbox / variables.tf
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

variable "public_subnet_ids" {
  description = "list of public subnets for the cluster"
  type        = "list"
}

variable "ssh_ip_address" {}

#--------------------------------------------------------------
# Common Settings
#--------------------------------------------------------------

variable "vpc_id" {}

variable "key_name" {}

#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------

variable "cluster_name" {}

variable "environment" {}

variable "owner" {}
