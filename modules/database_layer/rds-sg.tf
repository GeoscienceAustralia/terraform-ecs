#==============================================================
# Database / rds-sg.tf
#==============================================================

# Security groups for the RDS.

resource "aws_security_group" "rds" {
  name        = "${var.cluster}_${var.workspace}_ecs_rds_sg"
  description = "allow traffic from the instance sg"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "${var.db_port_num}"
    to_port         = "${var.db_port_num}"
    protocol        = "tcp"
    security_groups = ["${var.ecs_instance_sg_id}", "${var.jump_ssh_sg_id}", "${aws_security_group.lambda_sg.id}"]
  }

  tags {
    Name       = "ecs-rds-sg"
    Cluster    = "${var.cluster}"
    Workspace  = "${var.workspace}"
    Owner      = "${var.owner}"
    Created_by = "terraform"
  }
}

# In order to run lambda they must have permissions to create, describe and delete ENIs
# These can be given using: AWSLambdaVPCAccessExecutionRole policy
# More info: http://docs.aws.amazon.com/lambda/latest/dg/vpc.html

resource "aws_security_group" "lambda_sg" {
  name        = "${var.cluster}_${var.workspace}_lambda_rds_sg"
  description = "Allows traffic from lambda"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name       = "${var.cluster}-lambda-sg"
    Cluster    = "${var.cluster}"
    Workspace  = "${var.workspace}"
    Owner      = "${var.owner}"
    Created_by = "terraform"
  }
}
