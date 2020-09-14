resource "aws_network_interface" "www1" {
  subnet_id = aws_subnet.web-pub.id
  private_ips = ["10.1.254.10"]
  security_groups = [aws_security_group.web-pub-sg.id]  
  tags = {
    Name = "www1 eth0"
  }
}

resource "aws_instance" "www1" {
  ami = "ami-6ca48609"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  key_name = "chapter2_webserver"
  network_interface {
    network_interface_id = aws_network_interface.www1.id 
    device_index = 0    
  }
  tags = {
    Name = "www1"
  }
}

resource "aws_eip" "web-pub" {  
  vpc = true
}

resource "aws_eip_association" "web-pub" {
  network_interface_id = aws_network_interface.www1.id
  allocation_id = aws_eip.web-pub.id
  private_ip_address = "10.1.254.10"
}