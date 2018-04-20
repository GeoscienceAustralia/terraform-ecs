#==============================================================
# Database / rds.tf
#==============================================================

# Create a subnet group and rds

resource "aws_db_instance" "rds" {
  identifier = "${var.cluster}-${var.workspace}-${var.identifier}"

  # Instance parameters
  allocated_storage      = "${var.storage}"
  storage_type           = "gp2"
  instance_class         = "${var.instance_class}"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  db_subnet_group_name   = "${var.database_subnet_group}"

  # Availability
  multi_az = "${var.rds_is_multi_az}"

  # DB parameters
  name           = "${var.db_name}"
  username       = "${var.db_admin_username}"
  password       = "${var.db_admin_password}"
  engine         = "${var.engine}"
  engine_version = "${lookup(var.engine_version, var.engine)}"

  # Backup / Storage
  backup_window           = "${var.backup_window}"
  backup_retention_period = "${var.backup_retention_period}"
  storage_encrypted       = "${var.storage_encrypted}"

  # only for dev/test builds
  skip_final_snapshot = true

  tags {
    Name       = "${var.cluster}_ecs_rds"
    Cluster    = "${var.cluster}"
    Workspace  = "${var.workspace}"
    Owner      = "${var.owner}"
    Created_by = "terraform"
  }
}
