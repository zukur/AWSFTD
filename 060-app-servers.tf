###########################################
#### Search for Linux image
###########################################
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

###########################################
#### Deploy linux servers
###########################################
resource "aws_instance" "srv-a" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name = aws_key_pair.deployer.key_name
  user_data = file("srv-a_init.sh")

  network_interface {
    network_interface_id = aws_network_interface.srv-a-nic.id
    device_index = 0
  }

  depends_on = [
    aws_internet_gateway.igw-outside,
    aws_nat_gateway.natgw-a,
    aws_route_table_association.assoc-outside-a,
    aws_route_table_association.assoc-servers-a
  ]

  tags = {
    Name = "CL-FTD-srv-a"
  }
}

resource "aws_instance" "srv-b" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name = aws_key_pair.deployer.key_name
  user_data = file("srv-b_init.sh")

  network_interface {
    network_interface_id = aws_network_interface.srv-b-nic.id
    device_index = 0
  }

  depends_on = [
    aws_internet_gateway.igw-outside,
    aws_nat_gateway.natgw-b,
    aws_route_table_association.assoc-outside-b,
    aws_route_table_association.assoc-servers-b
  ]

  tags = {
    Name = "CL-FTD-srv-b"
  }
}