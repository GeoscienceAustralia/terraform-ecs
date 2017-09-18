#==============================================================
# Database / rds-sg.tf
#==============================================================

# Security groups for the RDS.

resource "aws_security_group" "rds" {
  name        = "${var.cluster_name}_${var.environment}_ecs_rds_sg"
  description = "allow traffic from the instance sg"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "${var.db_port_num}"
    to_port         = "${var.db_port_num}"
    protocol        = "tcp"
    security_groups = ["${var.ecs_instance_sg_id}", "${var.jump_ssh_sg_id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${var.ecs_instance_sg_id}"]
  }

  tags {
    Name        = "ecs-rds-sg"
    Cluster     = "${var.cluster_name}"
    Environment = "${var.environment}"
    Created_by  = "terraform"
    Owner       = "${var.owner}"
  }
}
