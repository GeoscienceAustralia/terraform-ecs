data "aws_kms_alias" "ssm" {
  name = "alias/parameter_store_key"
}

resource "aws_ssm_parameter" "efs_id" {
  name      = "${var.ssm_prefix}.${var.ssm_efs_id_ref}"
  value     = "${element(concat(aws_efs_file_system.efs.*.id, list("")), 0)}"
  type      = "String"
  overwrite = "${var.ssm_overwrite}"

  count = "${length(var.ssm_prefix) > 0 ? 1 : 0}"
}