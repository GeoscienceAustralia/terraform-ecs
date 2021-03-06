#==============================================================
# Database / dns.tf
#==============================================================

# Create a dns entry for the rds

resource "aws_route53_zone" "zone" {
  name = "${var.zone}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name       = "${var.cluster}_r53_zone"
    Cluster    = "${var.cluster}"
    Workspace  = "${var.workspace}"
    Owner      = "${var.owner}"
    Created_by = "terraform"
  }
}

resource "aws_route53_record" "record" {
  name = "${var.dns_name}"
  type = "A"
  zone_id = "${aws_route53_zone.zone.zone_id}"

  alias {
    name = "${aws_db_instance.rds.address}"
    zone_id = "${aws_db_instance.rds.hosted_zone_id}"
    evaluate_target_health = true
  }
}