vpc_cidr = "10.0.0.0/16"

cluster = "datacube-prod"

state_bucket = "dea-devs-tfstate"

workspace = "datacube-prod"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]

database_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]

availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

max_size = 10

min_size = 1

desired_capacity = 4

instance_type = "m5.2xlarge"

owner = "YOUR EMAIL HERE"

enable_jumpbox = true

key_name = "datacube-ecs-dea"

db_multi_az = true

dns_zone = "dea.ga.gov.au"

ssl_cert_region = "ap-southeast-2"
