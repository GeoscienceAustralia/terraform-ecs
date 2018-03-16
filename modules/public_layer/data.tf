# NAT Instance AMI search
# Will find the latest Amazon NAT Instance AMI for use
# by our compute nodes
data "aws_ami" "nat" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-hvm-*"]
  }

  owners = ["amazon"]
}
