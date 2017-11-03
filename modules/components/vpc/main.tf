#==============================================================
# VPC / main.tf
#==============================================================

# Creates a new VPC for the ECS cluster

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = true

  tags {
    Name       = "${var.cluster}"
    Workspace  = "${var.workspace}"
    Owner      = "${var.owner}"
    Created_by = "terraform"
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name       = "${var.cluster}"
    Workspace  = "${var.workspace}"
    Owner      = "${var.owner}"
    Created_by = "terraform"
  }
}
