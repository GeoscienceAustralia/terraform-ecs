#==============================================================
# Public / network.tf
#==============================================================

# Creates network resources required by the public subnet

resource "aws_route" "public_igw_route" {
  count                  = "${length(var.availability_zones)}"
  route_table_id         = "${element(var.public_route_table_ids, count.index)}"
  gateway_id             = "${var.vpc_igw_id}"
  destination_cidr_block = "${var.destination_cidr_block}"
}

resource "aws_eip" "nat" {
  vpc   = true
  count = "${var.enable_nat ? length(var.availability_zones) : 0}"
}
