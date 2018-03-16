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
  count = "${var.enable_nat ? length(var.public_subnet_cidrs) : 0}"
}
