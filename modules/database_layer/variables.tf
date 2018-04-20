#==============================================================
# Database / variables.tf
#==============================================================

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------

variable "database_subnet_group" {
  description = "Subnet group for the database"
}

variable "vpc_id" {}

#--------------------------------------------------------------
# Database
#--------------------------------------------------------------

variable "identifier" {
  default     = "mydb-rds"
  description = "Identifier for your DB"
}

variable "storage" {
  default     = "180"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "postgres"
  description = "Engine type: e.g. mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"

  default {
    postgres = "9.6.6"
  }
}

variable "instance_class" {
  default     = "db.m4.xlarge"
  description = "aws instance"
}

variable "db_name" {
  default     = "mydb"
  description = "Name of the first db"
}

variable "db_admin_username" {
  description = "Admin username for the database"
}

variable "db_admin_password" {
  description = "password should be provided by env variable"
}

variable "rds_is_multi_az" {
  default = false
}

variable "backup_retention_period" {
  # Days
  default = "30"
}

variable "backup_window" {
  # 12:00AM-03:00AM AEST
  default = "14:00-17:00"
}

variable "storage_encrypted" {
  default = false
}

variable "db_port_num" {
  default     = "5432"
  description = "Default port for database"
}

#--------------------------------------------------------------
# AWS SSM Configuration
#--------------------------------------------------------------

variable "ssm_prefix" {
  description = "If set, saves db parameters to the parameter store with the given prefix"
  default     = ""
}

variable "ssm_overwrite" {
  description = "If true any existing parameters will be overwritten"
  default     = "true"
}

variable "ssm_dbname_ref" {
  description = "The reference for the dbname in the ssm"
  default     = "db_name"
}

variable "ssm_adminuser_ref" {
  description = "The reference for the admin username in the ssm"
  default     = "admin_username"
}

variable "ssm_adminpassword_ref" {
  description = "The reference for the admin password in the ssm"
  default     = "admin_password"
}

variable "ssm_rdshost_ref" {
  description = "The reference for the rds host name in the ssm"
  default     = "host"
}

#--------------------------------------------------------------
# Security Groups
#--------------------------------------------------------------

variable "ecs_instance_sg_id" {
  description = "Security group id for containers"
}

variable "jump_ssh_sg_id" {
  description = "Security group id for the jumpbox"
}

#--------------------------------------------------------------
# Route53 DNS
#--------------------------------------------------------------

variable "dns_name" {
  default     = "database"
  description = "Database url prefix"
}

variable "zone" {
  default     = "local"
  description = "Route53 Zone suffix"
}

#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------

variable "cluster" {}

variable "workspace" {}

variable "owner" {}
