resource "aws_subnet" "subnet_servers-3b" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.14.0/24"
  availability_zone = var.az-b

  tags = {
    Name = "CL-FTD-Servers-3b"
  }
}

resource "aws_route_table_association" "assoc-servers-3b" {
  subnet_id      = aws_subnet.subnet_servers-3b.id
  route_table_id = aws_route_table.inside-b.id
}

resource "aws_network_interface" "linuxsrv-nic-3b" {
  subnet_id         = aws_subnet.subnet_servers-3b.id
  source_dest_check = false
  private_ips = ["10.42.14.101"]
  tags = {
      Name = "CL-FTD-linuxsrv3b-nic"
  }
}

resource "aws_network_interface_sg_attachment" "linuxsrv-nic_attachment3b" {
  security_group_id    = aws_security_group.srv-mgmt.id
  network_interface_id = aws_network_interface.linuxsrv-nic-3b.id
}

resource "aws_instance" "linux-srv3b" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name = aws_key_pair.deployer.key_name

  network_interface {
    network_interface_id = aws_network_interface.linuxsrv-nic-3b.id
    device_index = 0
  }

  tags = {
    Name = "CL-FTD-linuxsrv3b"
  }
}