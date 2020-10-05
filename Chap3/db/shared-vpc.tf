provider "aws" {    
  region = "us-east-2" 
}

resource "aws_vpc" "shared" {
  cidr_block = "10.2.0.0/16"
  tags = {
    Name = "shared-vpc"
  }
}

resource "aws_subnet" "database" {
  vpc_id = aws_vpc.shared.id
  cidr_block = "10.2.2.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "database"
  }
}

resource "aws_route_table" "shared" {
  vpc_id = aws_vpc.shared.id  
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.web-igw.id
#   }  
  tags = {
    Name = "shared-vpc-route-table"
  }
}

resource "aws_route_table_association" "shared" {
  subnet_id = aws_subnet.database.id  
  route_table_id = aws_route_table.shared.id  
}

output "shared_vpc_id" {
  value = aws_vpc.shared.id
  description = "shared vpc id"
}

output "shared_subnet_id" {
  value = aws_subnet.database.id
  description = "shared subnet id"
}

output "shared_vpc_route_table_id" {
  value = aws_route_table.shared.id
  description = "shared vpc route table id"
}