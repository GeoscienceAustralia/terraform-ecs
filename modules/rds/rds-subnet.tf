#==============================================================
# Database / db-subnets.tf
#==============================================================

# Create a subnet in each availability zone.

resource "aws_subnet" "database" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${var.vpc_id}"

  cidr_block        = "${element(var.database_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name         = "${var.cluster_name}-database-subnet-${var.environment}-${element(var.availability_zones, count.index)}"
    cluster_name = "${var.cluster_name}"
    environment  = "${var.environment}"
    created_by   = "terraform"
  }
}
