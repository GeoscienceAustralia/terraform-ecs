#==============================================================
# VPC / variables.tf
#==============================================================

variable "cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------

variable "cluster" {
  description = "The name of the cluster"
}

variable "owner" {
  description = "Contact mailing list for the workspace"
}

variable "workspace" {
  description = "The name of the workspace"
}
