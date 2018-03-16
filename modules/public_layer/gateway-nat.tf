# Using the AWS NAT Gateway service instead of a nat instance, it's more expensive but easier
# See comparison http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-comparison.html

resource "aws_nat_gateway" "nat" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(module.public_subnet.ids, count.index)}"
  count         = "${(var.enable_nat && var.enable_gateways) ? length(var.public_subnet_cidrs) : 0}"
}

# Creating a NAT Gateway takes some time. Some services need the internet (NAT Gateway) before proceeding. 
# Therefore we need a way to depend on the NAT Gateway in Terraform and wait until is finished. 
# Currently Terraform does not allow module dependency to wait on.
# Therefore we use a workaround described here: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534

resource "null_resource" "gateway_nat_complete" {
  depends_on = ["aws_nat_gateway.nat"]
}