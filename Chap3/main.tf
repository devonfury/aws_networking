provider "aws" {    
  region = "us-east-2" 
}

module "webserver" {
  source = "./webserver"    
}

module "db" {
  source = "./db"
}

resource "aws_vpc_perring_connection" "web_vpc-shared_vps-pcx" {
  peer_vpc_id = module.webserver.aws_vpc.web-vpc.id
  vpc_id = module.db.aws_vpc.shared.id
  auto_accept = true
  tags {
    Name = "web vpc to shared vpc connection"
  }
}