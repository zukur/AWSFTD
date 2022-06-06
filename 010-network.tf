# VPC
resource "aws_vpc" "vpc-1" {
  cidr_block = "10.42.0.0/16"
  tags = {
    Name = "CL-FTD-VPC"
  }
}

# Subnets AZ A
resource "aws_subnet" "subnet_outside-3a" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.1.0/24"
  availability_zone = var.az-a

  tags = {
    Name = "CL-FTD-Outside-3a"
  }
}

resource "aws_subnet" "subnet_inside-3a" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.2.0/24"
  availability_zone = var.az-a

  tags = {
    Name = "CL-FTD-Inside-3a"
  }
}

resource "aws_subnet" "subnet_management-3a" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.3.0/24"
  availability_zone = var.az-a

  tags = {
    Name = "CL-FTD-Management-3a"
  }
}

resource "aws_subnet" "subnet_servers-3a" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.4.0/24"
  availability_zone = var.az-a

  tags = {
    Name = "CL-FTD-Servers-3a"
  }
}

resource "aws_subnet" "subnet_oobmgmt-3a" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.250.0/24"
  availability_zone = var.az-a

  tags = {
    Name = "CL-FTD-OOB-Mgmt-3a"
  }
}

resource "aws_subnet" "subnet_diag-3a" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.255.0/24"
  availability_zone = var.az-a

  tags = {
    Name = "CL-FTD-Diag-3a"
  }
}

# Subnets AZ B
resource "aws_subnet" "subnet_outside-3b" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.11.0/24"
  availability_zone = var.az-b

  tags = {
    Name = "CL-FTD-Outside-3b"
  }
}

resource "aws_subnet" "subnet_inside-3b" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.12.0/24"
  availability_zone = var.az-b

  tags = {
    Name = "CL-FTD-Inside-3b"
  }
}

resource "aws_subnet" "subnet_management-3b" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.13.0/24"
  availability_zone = var.az-b

  tags = {
    Name = "CL-FTD-Management-3b"
  }
}

resource "aws_subnet" "subnet_diag-3b" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.42.254.0/24"
  availability_zone = var.az-b

  tags = {
    Name = "CL-FTD-Diag-3b"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw-outside" {
  vpc_id = aws_vpc.vpc-1.id

  tags = {
    Name = "CL-FTD-igw"
  }
}

# Nat Gateway pub IP
resource "aws_eip" "natgw-a-eip" {
  vpc = true
  tags = {
      Name = "CL-FTD-natgw-a-eip"
  }
}

resource "aws_eip" "natgw-b-eip" {
  vpc = true
  tags = {
      Name = "CL-FTD-natgw-b-eip"
  }
}

# Nat Gateway
resource "aws_nat_gateway" "natgw-a" {
  allocation_id = aws_eip.natgw-a-eip.id
  subnet_id = aws_subnet.subnet_outside-3a.id
  tags = {
    "name" = "CL-FTD-NatGw-a"
  }
  depends_on = [
    aws_internet_gateway.igw-outside
  ]
}

resource "aws_nat_gateway" "natgw-b" {
  allocation_id = aws_eip.natgw-b-eip.id
  subnet_id = aws_subnet.subnet_outside-3b.id
  tags = {
    "name" = "CL-FTD-NatGw-b"
  }
  depends_on = [
    aws_internet_gateway.igw-outside
  ]
}

# Route table
resource "aws_route_table" "outside" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-outside.id
  }

  tags = {
    Name = "CL-FTD-rt-outside"
  }
}

resource "aws_route_table" "inside-a" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    #network_interface_id = aws_network_interface.ftdv01-inside.id
    nat_gateway_id = aws_nat_gateway.natgw-a.id
  }

  tags = {
    Name = "CL-FTD-rt-inside-a"
  }
}

resource "aws_route_table" "inside-b" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    #network_interface_id = aws_network_interface.ftdv01-inside.id
    nat_gateway_id = aws_nat_gateway.natgw-b.id
  }

  tags = {
    Name = "CL-FTD-rt-inside-b"
  }
}

resource "aws_route_table_association" "assoc-outside-3a" {
  subnet_id      = aws_subnet.subnet_outside-3a.id
  route_table_id = aws_route_table.outside.id
}

#resource "aws_route_table_association" "assoc-inside-3a" {
#  subnet_id      = aws_subnet.subnet_inside-3a.id
#  route_table_id = aws_route_table.inside-a.id
#}

resource "aws_route_table_association" "assoc-oobmgmt-3a" {
  subnet_id      = aws_subnet.subnet_oobmgmt-3a.id
  route_table_id = aws_route_table.outside.id
}

resource "aws_route_table_association" "assoc-mgmt-3a" {
  subnet_id      = aws_subnet.subnet_management-3a.id
  route_table_id = aws_route_table.inside-a.id
}

resource "aws_route_table_association" "assoc-servers-3a" {
  subnet_id      = aws_subnet.subnet_servers-3a.id
  route_table_id = aws_route_table.inside-a.id
}

resource "aws_route_table_association" "assoc-outside-3b" {
  subnet_id      = aws_subnet.subnet_outside-3a.id
  route_table_id = aws_route_table.outside.id
}

#resource "aws_route_table_association" "assoc-inside-3b" {
#  subnet_id      = aws_subnet.subnet_inside-3b.id
#  route_table_id = aws_route_table.inside-b.id
#}