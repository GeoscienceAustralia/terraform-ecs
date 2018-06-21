vpc_cidr = "10.0.0.0/16"

cluster = "datacube-dev"

state_bucket = "ga-aws-dea-dev-tfstate"

workspace = "datacube-dev"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]

database_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]

availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

max_size = 6

max_container_num = 30

min_size = 1

min_container_num = 4

desired_capacity = 4

instance_type = "r4.4xlarge"

owner = "deacepticons"

enable_jumpbox = true

key_name = "datacube-dev"

db_multi_az = false

dns_zone = "wms.gadevs.ga"

ssl_cert_region = "ap-southeast-2"

config_root = "https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/"
