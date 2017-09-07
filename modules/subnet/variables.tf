variable "name" {
  description = "Name of the subnet, actual name will be, for example: name_eu-west-1a"
}

variable "environment" {
  description = "The name of the environment"
}

variable "cidrs" {
  type        = "list"
  description = "List of cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
}

variable "availability_zones" {
  type        = "list"
  description = "List of availability zones you want. Example: ap-southeast-2a, ap-southeast-2b"
}

variable "vpc_id" {
  description = "VPC id to place to subnet into"
}

variable "tier" {
  description = "Public or Private"
}

variable "owner" {
  description = "Mailing list for the resource"
}
