resource "aws_subnet" "subnet_servers-b" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.14.0/24"
  availability_zone = var.az-b

  tags = {
    Name = "CL-FTD-Servers-b"
  }
}

resource "aws_route_table_association" "assoc-servers-b" {
  subnet_id      = aws_subnet.subnet_servers-b.id
  route_table_id = aws_route_table.internal-b.id
}

resource "aws_network_interface" "srv-b-nic" {
  subnet_id         = aws_subnet.subnet_servers-b.id
  source_dest_check = false
  private_ips = ["10.42.14.101"]
  tags = {
      Name = "CL-FTD-srv-b-nic"
  }
}

resource "aws_network_interface_sg_attachment" "srv-b-nic_attachment" {
  security_group_id    = aws_security_group.srv-mgmt.id
  network_interface_id = aws_network_interface.srv-b-nic.id
}

resource "aws_instance" "srv-b" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name = aws_key_pair.deployer.key_name

  network_interface {
    network_interface_id = aws_network_interface.srv-b-nic.id
    device_index = 0
  }

  tags = {
    Name = "CL-FTD-srv-b"
  }
}