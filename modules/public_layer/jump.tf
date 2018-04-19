#==============================================================
# Public / jumpbox.tf
#==============================================================

# Create a jumpbox so we can have ssh access to the app server

resource "aws_instance" "jumpbox" {
  count = "${var.enable_jumpbox}"

  ami           = "${var.jumpbox_ami}"
  instance_type = "${var.jump_instance_type}"

  tags = {
    Name       = "${var.cluster}-${var.workspace}-jumpbox"
    Owner      = "${var.owner}"
    Cluster    = "${var.cluster}"
    Workspace  = "${var.workspace}"
    Created_by = "terraform"
  }

  subnet_id                   = "${element(var.public_subnets, 0)}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.jump_ssh_sg.id}"]
  key_name                    = "${var.key_name}"
}

resource "aws_eip" "jump" {
  count = "${var.enable_jumpbox}"

  instance = "${aws_instance.jumpbox.id}"
  vpc      = true
}
