output "efs_id" {
  value = "${element(concat(aws_efs_file_system.efs.*.id, list("")), 0)}"
}