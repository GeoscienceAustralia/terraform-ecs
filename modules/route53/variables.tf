variable "domain_name" {
  type = "string"
}

variable "zone_domain_name" {
  type = "string"
}

variable "private_zone" {
  default = false
}

variable "record_type" {
  type = "string"
  default = "A"
}

variable "target_dns_name" {
  type = "string"
}

variable "target_dns_zone_id" {
  type = "string"
}

variable "evaluate_target_health" {
  default = true
}