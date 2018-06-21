#==============================================================
# App / efs.tf
#==============================================================

# Elastic File System to host application files

resource "aws_efs_file_system" "efs" {
  count = "${var.enable}"
  tags {
    Name      = "${var.cluster}_${var.workspace}_efs"
    owner     = "${var.owner}"
    workspace = "${var.workspace}"
    cluster   = "${var.cluster}"
  }
}

# Mount targets will require the private subnet info
# from the ec2 module in order to connect to them
resource "aws_efs_mount_target" "efs_mount_target" {
  count           = "${var.enable ? length(var.availability_zones) : 0}"
  file_system_id  = "${aws_efs_file_system.efs.0.id}"
  subnet_id       = "${element(var.private_subnet_ids, count.index)}"
  security_groups = ["${aws_security_group.mount_target_sg.id}"]
}

resource "aws_security_group" "mount_target_sg" {
  count       = "${var.enable}"
  name        = "${var.cluster}_${var.workspace}_inbound_nfs"
  description = "Allow NFS (EFS) access inbound"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    security_groups = ["${var.ecs_instance_security_group_id}"]
  }

  tags {
    Name        = "${var.cluster}_${var.workspace}_inbound_nfs"
    managed_by  = "Terraform"
    owner       = "${var.owner}"
    workspace = "${var.workspace}"
    cluster  = "${var.cluster}"
  }
}