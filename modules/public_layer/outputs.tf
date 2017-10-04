#==============================================================
# Public / outputs.tf
#==============================================================

output "jump_ssh_sg_id" {
  value = "${aws_security_group.jump_ssh_sg.id}"
}

output "nat_ids" {
  value = ["${aws_nat_gateway.nat.*.id}"]
}

output "nat_complete" {
  value = "${null_resource.nat_complete.id}"
}

output "ecs_lb_role" {
  value = "${aws_iam_role.ecs_lb_role.id}"
}
