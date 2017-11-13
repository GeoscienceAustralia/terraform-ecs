#==============================================================
# VPC / outputs.tf
#==============================================================

output "id" {
  value = "${aws_vpc.vpc.id}"
}

output "cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "igw_id" {
  value = "${aws_internet_gateway.vpc.id}"
}
