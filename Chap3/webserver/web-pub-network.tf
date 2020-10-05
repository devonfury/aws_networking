resource "aws_vpc" "web-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "web-vpc"
  }
}

resource "aws_internet_gateway" "web-igw" {
  vpc_id = aws_vpc.web-vpc.id
  tags = {
    Name = "web-igw"
  }
}

resource "aws_subnet" "web-pub" {
  vpc_id = aws_vpc.web-vpc.id
  cidr_block = "10.1.254.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "web-pub"
  }
}

resource "aws_route_table" "web-pub" {
  vpc_id = aws_vpc.web-vpc.id  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-igw.id
  }
  tags = {
    Name = "web-pub-route-table"
  }
}

resource "aws_route_table_association" "web-pub" {
  subnet_id = aws_subnet.web-pub.id  
  route_table_id = aws_route_table.web-pub.id  
}

resource "aws_security_group" "web-pub-sg" {
  name = "web-pub-sg"
  vpc_id = aws_vpc.web-vpc.id
  ingress {
    description = "SSH-In"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["71.201.234.0/32"]
  }
  ingress {
    description = "HTTP-In"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "ICMP-Out"
    from_port = -1
    to_port = -1
    protocol = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-pub-sg"
  }
}
