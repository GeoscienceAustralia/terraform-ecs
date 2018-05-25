# Write cluster level variables to parameter store, so tasks can query them

data "aws_kms_alias" "ssm" {
  name = "alias/parameter_store_key"
}

resource "aws_ssm_parameter" "dns_zone" {
  name      = "${var.cluster}.dns_zone"
  value     = "${var.dns_zone}"
  type      = "String"
  overwrite = true
}

resource "aws_ssm_parameter" "ssl_cert_region" {
  name      = "${var.cluster}.ssl_cert_region"
  value     = "${var.ssl_cert_region}"
  type      = "String"
  overwrite = true
}

resource "aws_ssm_parameter" "state_bucket" {
  name      = "${var.cluster}.state_bucket"
  value     = "${var.state_bucket}"
  type      = "String"
  overwrite = true
}
