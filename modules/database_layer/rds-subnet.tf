#==============================================================
# Database / rds-subnet.tf
#==============================================================

# Create a subnet in each availability zone.

resource "aws_subnet" "database" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${var.vpc_id}"

  cidr_block        = "${element(var.database_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name       = "${var.cluster}-database-subnet-${var.workspace}-${element(var.availability_zones, count.index)}"
    Cluster    = "${var.cluster}"
    Workspace  = "${var.workspace}"
    Created_by = "terraform"
    Owner      = "${var.owner}"
  }
}
