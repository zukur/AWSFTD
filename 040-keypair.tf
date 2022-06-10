###########################################
#### Create SSH keypair
###########################################
resource "aws_key_pair" "deployer" {
  key_name   = "CL-FTD-key"
  public_key = file("cl-ftd.pem.pub")
 }
