vpc_cidr = "10.0.0.0/16"

cluster_name = "datacube-ecs"

environment = "dev"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

private_subnet_cidrs = ["10.0.50.0/24", "10.0.51.0/24"]

availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

max_size = 3

min_size = 1

desired_capacity = 2

instance_type = "t2.small"

ecs_aws_ami = "ami-c1a6bda2"

owner = "alexander.vincent@ga.gov.au"

enable_jumpbox = true

db_admin_username = "supersecretuser"
db_admin_password = "sup3rs3cr3tP4ssw0rd"
ssh_ip_address = "192.104.44.129/32"
#ssh_ip_address = "1.144.97.243/32"
