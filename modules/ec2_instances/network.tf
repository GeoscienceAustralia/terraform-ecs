#==============================================================
# ec2_instances / network.tf
#==============================================================

# Creates the instance route tables

resource "aws_route" "private_nat_route" {
  count                  = "${var.enable_nat && var.enable_gateways ? length(var.availability_zones) : 0}"
  route_table_id         = "${element(var.private_route_table_ids, count.index)}"
  nat_gateway_id         = "${element(var.nat_ids, count.index)}"
  destination_cidr_block = "${var.destination_cidr_block}"
}

resource "aws_route" "private_nat_instance_route" {
  count                  = "${var.enable_nat && !var.enable_gateways ? length(var.availability_zones) : 0}"
  route_table_id         = "${element(var.private_route_table_ids, count.index)}"
  destination_cidr_block = "${var.destination_cidr_block}"
  instance_id            = "${element(var.nat_instance_ids, count.index)}"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = "${var.vpc_id}"
  service_name    = "com.amazonaws.ap-southeast-2.s3"
  route_table_ids = ["${var.private_route_table_ids}"]
}
