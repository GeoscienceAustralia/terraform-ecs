#==============================================================
# App / efs.tf
#==============================================================

# Elastic File System to host the app files

resource "aws_efs_file_system" "efs" {
  tags {
    Name        = "${var.cluster}_${var.workspace}_efs"
    owner       = "${var.owner}"
    workspace = "${var.workspace}"
    cluster  = "${var.cluster}"
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  count           = "${length(var.availability_zones)}"
  file_system_id  = "${aws_efs_file_system.efs.id}"
  subnet_id       = "${element(module.private_subnet.ids, count.index)}"
  security_groups = ["${aws_security_group.mount_target_sg.id}"]
}

resource "aws_security_group" "mount_target_sg" {
  name        = "${var.cluster}_${var.workspace}_inbound_nfs"
  description = "Allow NFS (EFS) access inbound"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    security_groups = ["${aws_security_group.instance.id}"]
  }

  tags {
    Name        = "${var.cluster}_${var.workspace}_inbound_nfs"
    managed_by  = "Terraform"
    owner       = "${var.owner}"
    workspace = "${var.workspace}"
    cluster  = "${var.cluster}"
  }
}