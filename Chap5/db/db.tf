resource "aws_security_group" "db1-sg" {
  name = "db1-sg"
  vpc_id = aws_vpc.shared.id
  ingress {
    description = "SSH-In"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["192.168.0.0/16","10.2.0.0/16"]
  }
  ingress {
    description = "MySQL-In"
    from_port = 3306
    to_port = 3306
    protocol = "TCP"
    cidr_blocks = ["10.1.254.0/24"]
  }
  ingress {
    description = "ICMP-In"
    from_port = -1
    to_port = -1
    protocol = "ICMP"
    cidr_blocks = ["10.1.254.0/24"]
  }
  egress {
    description = "ICMP-Out"
    from_port = -1
    to_port = -1
    protocol = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "db1-sg"
  }
}

resource "aws_network_interface" "db1" {
  subnet_id = aws_subnet.database.id
  private_ips = ["10.2.2.41"]
  security_groups = [aws_security_group.db1-sg.id]  
  tags = {
    Name = "db1 eth0"
  }
}

resource "aws_instance" "db1" {
  ami = "ami-6ca48609"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  key_name = "chapter2_webserver"
  network_interface {
    network_interface_id = aws_network_interface.db1.id 
    device_index = 0    
  }
  tags = {
    Name = "db1"
  }
}

output "ec2_instance_db1_id" {
  value = aws_instance.db1.id
}

output "ec2_instance_db1_private_ip" {
  value = aws_instance.db1.private_ip
}