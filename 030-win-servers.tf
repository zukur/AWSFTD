resource "aws_key_pair" "deployer" {
  key_name   = "CL-FTD-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuEdjlpY9ZpKUeSVdSkWGwMX0qKRz0uUsX70LshjTIRyvTH22viLS2EVJg4/3EdJCgx24aNcdDdThTyR9o3sYcoh/Xy3U0Yq/0LaAA3fjOSJIqeSakWHEI0brmCqvok0koWr7rTJXpPS3euhD2lobsDiStQIJmS8aSSN5Fdqv6jHxfByKYBDqQPDZWgUsS4GtgFhvj+4EmuNTiaVpMx5grBQmhEs0tm9cbh+TO/BA1tdm26fmU2iKnKq9onVPpBborU7c/f5EZN5VQSGFQo8WDRqzzcdtywk+5a5fTMKYRc0jzwC6wRdcFnQj/p1qw+e1a1PxPdkaNHdY/ZWavOvg83J3PPR3SL9gi+5eGtC0RzvBC5VSuhOLBPurfr8uvi20OVlnvTuZ3fo5pipxureZn7ZycAA4nHbOUweUxJ9j8D3elvdY4duBA0xKA7Y9mEFyn8ebXXv8o9lfD6+2kUvhtDh4WW8wvMtDQ6b+Vq4irqqIT+9JdjTjFusC5iigKHSM= bth@example.com"
 }

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
