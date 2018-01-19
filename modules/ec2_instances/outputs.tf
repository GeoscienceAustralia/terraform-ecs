#==============================================================
# ec2_instances / outputs.tf
#==============================================================

output "ecs_instance_security_group_id" {
  value = "${aws_security_group.instance.id}"
}

output "private_subnet_ids" {
  value = "${module.private_subnet.ids}"
}

output "private_subnet_route_table_ids" {
  value = "${module.private_subnet.route_table_ids}"
}
