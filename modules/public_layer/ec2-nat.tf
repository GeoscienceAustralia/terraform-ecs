resource "aws_instance" "ec2_nat" {
  ami = "${data.aws_ami.nat.id}"
  instance_type = "t2.micro"

  vpc_security_group_ids = [ "${aws_security_group.nat_sg.id}", "${aws_security_group.jump_ssh_sg.id}" ]

  availability_zone = "${element(var.availability_zones, count.index)}"

  count = "${(var.enable_nat && !var.enable_gateways) ? length(var.public_subnet_cidrs) : 0}"
}

resource "aws_eip_association" "eip_ec2" {
  instance_id   = "${element(aws_instance.ec2_nat.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"

  count = "${(var.enable_nat && !var.enable_gateways) ? length(var.public_subnet_cidrs) : 0}"
}

# Some services need the internet (NAT Gateway) before proceeding. 
# Therefore we need a way to depend on the NAT Gateway in Terraform and wait until is finished. 
# Currently Terraform does not allow module dependency to wait on.
# Therefore we use a workaround described here: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534

resource "null_resource" "ec2_nat_complete" {
  depends_on = ["aws_instance.ec2_nat"]
}

resource "aws_security_group" "nat_sg" {

  name        = "${var.cluster}_${var.workspace}_nat_sg"
  description = "Security group for NAT traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "-1"
    cidr_blocks = "${var.private_subnet_cidrs}"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "-1"
    cidr_blocks = "${var.private_subnet_cidrs}"
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "-1"
    cidr_blocks     = ["${var.destination_cidr_block}"]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "-1"
    cidr_blocks     = ["${var.destination_cidr_block}"]
  }

  count = "${(var.enable_nat && !var.enable_gateways) ? 1 : 0}"

  tags {
    Name       = "${var.cluster}-${var.workspace}-nat-sg"
    Owner      = "${var.owner}"
    Cluster    = "${var.cluster}"
    Workspace  = "${var.workspace}"
    Created_by = "terraform"
  }
}