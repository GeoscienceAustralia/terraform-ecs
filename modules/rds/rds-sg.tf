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
    protocol        = "TCP"
    security_groups = ["${var.ecs_instance_sg_id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = ["${var.ecs_instance_sg_id}"]
  }

  tags {
    Name         = "${var.cluster_name}-${var.environment}-ecs-rds-sg"
    cluster_name = "${var.cluster_name}"
    environment  = "${var.environment}"
    created_by   = "terraform"
  }
}
