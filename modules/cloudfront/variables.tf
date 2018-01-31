variable "origin_domain" {
  type        = "string"
  description = "Domain name of the origin website/service"
}

variable "origin_id" {
  default     = "default_origin"
  description = "User defined unique ID for the the origin"
}

variable "enable" {
  default = false
}

variable "aliases" {
  type         = "list"
  default      = [""]
  description = "List of aliases for the distribution, e.g. wms.datacube.org.au"
}

variable "enable_ipv6" {
  default = true
}

variable "default_allowed_methods" {
  default = ["GET", "HEAD"]
}

variable "default_cached_methods" {
  default = ["GET", "HEAD"]
}

variable "min_ttl" {
  default = 0
}

variable "max_ttl" {
  default = 31536000
}

variable "default_ttl" {
  default = 86400
}

variable "price_class" {
  default     = "PriceClass_All"
  description = "The Price class for this distribution, can be PriceClass_100, PriceClass_200 or PriceClass_All"
}