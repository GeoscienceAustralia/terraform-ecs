#==============================================================
# ec2_instances / network.tf
#==============================================================

# Creates the instance subnet and route table

module "private_subnet" {
  source = "../subnet"

  name               = "${var.cluster}-${var.workspace}_private_subnet"
  vpc_id             = "${var.vpc_id}"
  cidrs              = "${var.private_subnet_cidrs}"
  availability_zones = "${var.availability_zones}"

  # Tags
  owner     = "${var.owner}"
  workspace = "${var.workspace}"
  tier      = "Private"
}

resource "aws_route" "private_nat_route" {
  count                  = "${var.enable_nat ? length(var.private_subnet_cidrs) : 0}"
  route_table_id         = "${element(module.private_subnet.route_table_ids, count.index)}"
  nat_gateway_id         = "${element(var.nat_ids, count.index)}"
  destination_cidr_block = "${var.destination_cidr_block}"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = "${var.vpc_id}"
  service_name    = "com.amazonaws.ap-southeast-2.s3"
  route_table_ids = [ "${module.private_subnet.route_table_ids}" ]
}