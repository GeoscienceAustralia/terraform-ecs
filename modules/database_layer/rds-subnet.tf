#==============================================================
# Database / rds-subnet.tf
#==============================================================

# Create a subnet in each availability zone.

module "database_subnet" {
  source = "../subnet"

  name               = "${var.cluster}-${var.workspace}_database_subnet"
  vpc_id             = "${var.vpc_id}"
  cidrs              = "${var.database_subnet_cidrs}"
  availability_zones = "${var.availability_zones}"

  # Tags
  owner     = "${var.owner}"
  workspace = "${var.workspace}"
  tier      = "Database"
}

resource "aws_db_subnet_group" "rds-subnet" {
  name        = "${var.cluster}_${var.workspace}_rds_subnet_group"
  description = "${var.cluster} RDS Subnet Group"
  subnet_ids  = ["${module.database_subnet.ids}"]

  tags {
    Name       = "${var.cluster}_${var.workspace}_ecs_rds_subnet_group"
    Cluster    = "${var.cluster}"
    Workspace  = "${var.workspace}"
    Owner      = "${var.owner}"
    Created_by = "terraform"
  }
}
