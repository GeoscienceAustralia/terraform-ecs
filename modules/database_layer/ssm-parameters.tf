#==============================================================
# Database / ssm-parameters.tf
#==============================================================
data "aws_kms_alias" "ssm" {
  name = "alias/parameter_store_key"
}

resource "aws_ssm_parameter" "rds_db_name" {
  name      = "${var.ssm_prefix}.${var.ssm_dbname_ref}"
  value     = "${var.db_name}"
  type      = "String"
  overwrite = "${var.ssm_overwrite}"

  count = "${length(var.ssm_prefix) > 0 ? 1 : 0}"
}

resource "aws_ssm_parameter" "rds_admin_username" {
  name      = "${var.ssm_prefix}.${var.ssm_adminuser_ref}"
  value     = "${var.db_admin_username}"
  type      = "String"
  overwrite = "${var.ssm_overwrite}"

  count = "${length(var.ssm_prefix) > 0 ? 1 : 0}"
}

resource "aws_ssm_parameter" "rds_admin_password" {
  name      = "${var.ssm_prefix}.${var.ssm_adminpassword_ref}"
  value     = "${var.db_admin_password}"
  type      = "SecureString"
  overwrite = "${var.ssm_overwrite}"
  key_id    = "${data.aws_kms_alias.ssm.target_key_id}"

  count = "${length(var.ssm_prefix) > 0 ? 1 : 0}"
}

resource "aws_ssm_parameter" "rds_host" {
  name      = "${var.ssm_prefix}.${var.ssm_rdshost_ref}"
  value     = "${aws_db_instance.rds.endpoint}"
  type      = "String"
  overwrite = "${var.ssm_overwrite}"

  count = "${length(var.ssm_prefix) > 0 ? 1 : 0}"
}
