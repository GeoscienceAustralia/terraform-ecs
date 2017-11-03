vpc_cidr = "10.0.0.0/16"

cluster_name = "test-ecs"

workspace = "dev"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

private_subnet_cidrs = ["10.0.50.0/24", "10.0.51.0/24"]

availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

max_size = 3

min_size = 1

desired_capacity = 2

instance_type = "t2.small"

ecs_aws_ami = "ami-c1a6bda2"

owner = "YOUR EMAIL HERE"

enable_jumpbox = false

key_name = "AWS KEYNAME HERE"

