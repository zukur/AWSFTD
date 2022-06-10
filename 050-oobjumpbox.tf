###########################################
#### Search for Windows image
###########################################
data "aws_ami" "win2022" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["801119661308"]
}

###########################################
#### Deploy OOB Jumpbox
###########################################
resource "aws_instance" "oobjumpbox" {
  ami           = data.aws_ami.win2022.id
  instance_type = "t3.small"
  key_name = aws_key_pair.deployer.key_name
  get_password_data = true

  network_interface {
    network_interface_id = aws_network_interface.oobjumpbox-nic.id
    device_index = 0
  }

  tags = {
    Name = "CL-FTD-OOBJumpbox"
  }
}
