#==============================================================
# Database / outputs.tf
#==============================================================

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------

variable "database_subnet_cidr" {
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  description = "List of subnets to be used for databases"
}

variable "availability_zones" {
  type = "list"
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
    postgres = "9.6.5"
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
# Other Module Vars
#--------------------------------------------------------------

variable "ecs_instance_sg_id" {
  description = "Security group id for containers"
}

#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------

variable "cluster_name" {}

variable "environment" {}

variable "owner" {}
