provider "aws" {    
  region = "us-east-2" 
}

module "webserver" {
  source = "./webserver"    
}

module "db" {
  source = "./db"
  shared_vpc_id = module.shared-vpc.shared_vpc_id
  db_subnet = module.shared-vpc.shared_subnet_id
}

module "shared-vpc" {
  source = "./shared-vpc"
}

module "nat" {
  source = "./nat"
  shared_vpc_id = module.shared-vpc.shared_vpc_id
}

resource "aws_vpc_peering_connection" "web_vpc-shared_vpc-pcx" {
  peer_vpc_id = module.webserver.web-pub_vpc_id
  vpc_id = module.shared-vpc.shared_vpc_id
  auto_accept = true
  tags = {
    Name = "web vpc to shared vpc connection"
  }
}

resource "aws_route" "web_vpc-to-shared_vpc" {
  route_table_id = module.webserver.web_pub_route_table_id
  destination_cidr_block = "10.2.2.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.web_vpc-shared_vpc-pcx.id
}

resource "aws_route" "shared_vpc-to-web_vpc" {
  route_table_id = module.shared-vpc.shared_vpc_route_table_id 
  destination_cidr_block = "10.1.254.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.web_vpc-shared_vpc-pcx.id
}

resource "aws_route" "shared_vpc-default_route" {
  route_table_id = module.shared-vpc.shared_vpc_route_table_id 
  destination_cidr_block = "0.0.0.0/0"
  instance_id = module.nat.nat_ec2_instance_id
}

output "web-shared_pcx_id" {
  value = aws_vpc_peering_connection.web_vpc-shared_vpc-pcx.id
  description = "web to shared vpc pcx id"
}

