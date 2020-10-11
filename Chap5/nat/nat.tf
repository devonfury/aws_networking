variable "shared_vpc_id" {}

resource "aws_internet_gateway" "nat-igw" {
  vpc_id = var.shared_vpc_id #module.db.shared_vpc_id 
  tags = {
    Name = "nat-igw"
  }
}

resource "aws_subnet" "nat-pub" {
  vpc_id = var.shared_vpc_id #module.db.shared_vpc_id
  cidr_block = "10.2.254.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "nat-pub"
  }
}

resource "aws_route_table" "nat-pub" {
  vpc_id = var.shared_vpc_id #module.db.shared_vpc_id  
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

resource "aws_security_group" "nat-instance-sg" {
  name = "nat-instance-sg"
  vpc_id = var.shared_vpc_id #aws_vpc.shared.id
  ingress {
    description = "SSH-In"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["71.201.234.0/32"]
  }
  ingress {
    description = "TCP-In"
    from_port = 0
    to_port = 65535
    protocol = "TCP"
    cidr_blocks = ["10.0.0.0/8","192.168.0.0/16"]
  }
}
resource "aws_network_interface" "nat-ec2-instance" {
  subnet_id = aws_subnet.nat-pub.id
  private_ips = ["10.2.2.254"]
  security_groups = [aws_security_group.nat-instance-sg.id]  
  tags = {
    Name = "nat-ec2-instance eth0"
  }
}

resource "aws_instance" "nat-ec2-instance" {
  ami = "ami-00b34bbb100d6cfa1"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  key_name = "chapter2_webserver"
  network_interface {
    network_interface_id = aws_network_interface.nat-ec2-instance.id 
    device_index = 0    
  }
  source_dest_check = false
  tags = {
    Name = "nat-ec2-instance"
  }
}

resource "aws_eip" "nat-instance-eip" {
  instance = aws_instance.nat-ec2-instance.id
}