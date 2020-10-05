resource "aws_internet_gateway" "nat-igw" {
  vpc_id = module.db.shared_vpc_id 
  tags = {
    Name = "nat-igw"
  }
}

resource "aws_subnet" "nat-pub" {
  vpc_id = module.db.shared_vpc_id
  cidr_block = "10.2.254.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "nat-pub"
  }
}

resource "aws_route_table" "nat-pub" {
  vpc_id = module.db.shared_vpc_id  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat-igw.id
  }  
  tags = {
    Name = "nat-pub-vpc-route-table"
  }
}

resource "aws_route_table_association" "shared" {
  subnet_id = aws_subnet.nat-pub.id  
  route_table_id = aws_route_table.nat-pub.id  
}