#==============================================================
# Public / outputs.tf
#==============================================================

output "jump_ssh_sg_id" {
  value = "${aws_security_group.jump_ssh_sg.id}"
}

output "nat_ids" {
  value = "${split(",", (var.enable_nat && var.enable_gateways) ? join(",", aws_nat_gateway.nat.*.id) : join(",", list()))}"
}

output "nat_complete" {
  value = "${!var.enable_nat ? "" : var.enable_gateways ? null_resource.gateway_nat_complete.id : null_resource.ec2_nat_complete.id}"
}

output "ecs_lb_role" {
  value = "${aws_iam_role.ecs_lb_role.id}"
}

output "public_subnet_ids" {
  value = "${module.public_subnet.ids}"
}
