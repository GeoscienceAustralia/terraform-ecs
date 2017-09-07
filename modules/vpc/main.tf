resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = true

  tags {
    Name        = "${var.cluster}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.cluster}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
  }
}
