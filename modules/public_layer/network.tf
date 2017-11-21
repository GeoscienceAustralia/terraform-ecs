#==============================================================
# Public / network.tf
#==============================================================

# Creates network resources required by the public subnet

module "public_subnet" {
  source = "../subnet"

  name               = "${var.cluster}-${var.workspace}_public_subnet"
  vpc_id             = "${var.vpc_id}"
  cidrs              = "${var.public_subnet_cidrs}"
  availability_zones = "${var.availability_zones}"

  # Tags
  workspace = "${var.workspace}"
  owner     = "${var.owner}"
  tier      = "Public"
}

resource "aws_route" "public_igw_route" {
  count                  = "${length(var.public_subnet_cidrs)}"
  route_table_id         = "${element(module.public_subnet.route_table_ids, count.index)}"
  gateway_id             = "${var.vpc_igw_id}"
  destination_cidr_block = "${var.destination_cidr_block}"
}

resource "aws_eip" "nat" {
  vpc   = true
  count = "${var.public_subnet_count}"
}

# Using the AWS NAT Gateway service instead of a nat instance, it's more expensive but easier
# See comparison http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-comparison.html

resource "aws_nat_gateway" "nat" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(module.public_subnet.ids, count.index)}"
  count         = "${var.public_subnet_count}"
}

# Creating a NAT Gateway takes some time. Some services need the internet (NAT Gateway) before proceeding. 
# Therefore we need a way to depend on the NAT Gateway in Terraform and wait until is finished. 
# Currently Terraform does not allow module dependency to wait on.
# Therefore we use a workaround described here: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534

resource "null_resource" "nat_complete" {
  depends_on = ["aws_nat_gateway.nat"]
}
