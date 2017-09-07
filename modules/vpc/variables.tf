variable "cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  description = "The name of the cluster"
}

variable "owner" {
  description = "Contact mailing list for the environment"
}
