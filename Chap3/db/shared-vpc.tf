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