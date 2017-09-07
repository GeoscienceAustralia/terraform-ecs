#==============================================================
# Jumpbox / jump-sg.tf
#==============================================================

# Security groups for Jumpbox

resource "aws_security_group" "jump_ssh_sg" {
  # Allow SSH to jump host
  name = "jump_ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_ip_address}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "${var.cluster_name}-${var.environment}-jump_ssh"
    Owner       = "${var.owner}"
    Cluster     = "${var.cluster_name}"
    Environment = "${var.environment}"
    Created_by  = "terraform"
  }
}

resource "aws_security_group" "ssh_from_jump_sg" {
  # Allow SSH from jump host(s)
  name = "ssh_from_jump"

  ingress {
    from_port                                 = 22
    to_port                                   = 22
    protocol                                  = "tcp"

    security_groups                           = [
      "${aws_security_group.jump_ssh_sg.id}",
    ]
  }

  vpc_id                                      = "${var.vpc_id}"

  tags {
    Name                                      = "${var.cluster_name}-${var.environment}-ssh_from_jump"
    Owner                                     = "${var.owner}"
    Cluster                                   = "${var.cluster_name}"
    Environment                               = "${var.environment}"
    Created_by                                = "terraform"
  }
}
