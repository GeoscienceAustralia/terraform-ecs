
resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.family}"
  container_definitions = "${var.container_definitions}"
  task_role_arn = "${var.task_role_arn}"
  volume {
    name = "${var.volume_name}",
    host_path = "${var.container_path}"
  }
}


resource "aws_ecs_service" "service_definition" {
  name = "${var.name}"
  cluster = "${var.cluster}"
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count = "${var.desired_count}"
  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name = "${var.container_name}"
    container_port = "${var.container_port}"
  }
}
