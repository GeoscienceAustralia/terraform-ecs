vpc_cidr = "10.0.0.0/16"

cluster_name = "datacube-prod"

workspace = "datacube-prod"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]

database_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]

availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

max_size = 3

min_size = 1

desired_capacity = 2

instance_type = "t2.small"

owner = "YOUR EMAIL HERE"

enable_jumpbox = false

key_name = "datacube-ecs-dea"

db_multi_az = true
