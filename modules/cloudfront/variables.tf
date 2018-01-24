variable "origin_domain" {
  type = "string"
  description = "Domain name of the origin website/service"
  default = ""
}

variable "enable" {
  default = false
}

variable "origin_id" {
  default = "default_origin"
}

variable "aliases" {
  type = "list"
  default = [""]
}