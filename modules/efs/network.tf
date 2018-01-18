#==============================================================
# efs / network.tf
#==============================================================

# Create the routes - will require input from the ec2_instance
# module in order to connect to those machines.

resource "aws_route" "private_nat_route" {
  count                  = "${length(var.private_subnet_cidrs)}"
  route_table_id         = "${element(var.route_table_ids, count.index)}"
  nat_gateway_id         = "${element(var.nat_ids, count.index)}"
  destination_cidr_block = "${var.destination_cidr_block}"
}
