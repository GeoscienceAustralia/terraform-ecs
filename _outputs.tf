output "alb_dns_name" {
  value = "${module.load_balancer.alb_dns_name}"
}

output "ecs_policy_role_arn" {
  value = "${module.ecs_policy.role_arn}"
}

output "alb_target_group_arn" {
  value = "${module.load_balancer.alb_target_group}"
}