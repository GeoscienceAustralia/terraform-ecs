#==============================================================
# RDS / main.tf
#==============================================================

# Create a subnet group and rds

resource "aws_db_instance" "rds" {
  identifier              = "${var.cluster_name}-${var.environment}-${var.identifier}"
  allocated_storage       = "${var.storage}"
  storage_type            = "gp2"
  engine                  = "${var.engine}"
  engine_version          = "${lookup(var.engine_version, var.engine)}"
  instance_class          = "${var.instance_class}"
  name                    = "${var.db_name}"
  username                = "${var.db_admin_username}"
  password                = "${var.db_admin_password}"
  vpc_security_group_ids  = ["${aws_security_group.rds.id}"]
  multi_az                = "${var.rds_is_multi_az}"
  db_subnet_group_name    = "${aws_db_subnet_group.rds-subnet.id}"
  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"
  storage_encrypted       = "${var.storage_encrypted}"

  # only for dev/test builds
  skip_final_snapshot = true

  tags {
    Name        = "${var.cluster_name}_ecs_rds"
    Cluster     = "${var.cluster_name}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    Created_by  = "terraform"
  }
}

resource "aws_db_subnet_group" "rds-subnet" {
  name        = "${var.cluster_name}_${var.environment}_rds_subnet_group"
  description = "${var.cluster_name} RDS Subnet Group"
  subnet_ids  = ["${aws_subnet.database.*.id}"]

  tags {
    Name        = "${var.cluster_name}_${var.environment}_ecs_rds_subnet_group"
    Cluster     = "${var.cluster_name}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    Created_by  = "terraform"
  }
}
