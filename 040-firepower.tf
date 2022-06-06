data "aws_ami" "fmcv" {
  most_recent = true
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["fmcv-7.1.0-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ftd" {
  most_recent = true
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["ftdv-7.1.0-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "fmcv" {
  ami           = data.aws_ami.fmcv.id
  instance_type = "c5.4xlarge"
  key_name = aws_key_pair.deployer.key_name

  network_interface {
    network_interface_id = aws_network_interface.fmc-mgmt.id
    device_index = 0
  }

  user_data = templatefile("fmc_startup_file.txt", {password = var.password})

  tags = {
    Name = "CL-FTD-FMCv"
  }
}

resource "aws_instance" "ftdv01" {
  ami           = data.aws_ami.ftd.id
  instance_type = "c5.xlarge"

  network_interface {
    network_interface_id = aws_network_interface.ftdv01-management.id
    device_index = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.ftdv01-diag.id
    device_index = 1
  }
  network_interface {
    network_interface_id = aws_network_interface.ftdv01-outside.id
    device_index = 2
  }
  network_interface {
    network_interface_id = aws_network_interface.ftdv01-inside.id
    device_index = 3
  }

  user_data = templatefile("ftdv01_startup_file.txt", {password = var.password})

  tags = {
    Name = "CL-FTD-FTDv01"
  }
}
