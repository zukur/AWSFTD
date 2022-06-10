###########################################
#### Print outputs to the terminal
###########################################
output "oobjumpbox_Administrator_Password" {
   value = rsadecrypt(aws_instance.oobjumpbox.password_data,file("cl-ftd.pem.prv"))
 }

 output "oobjumpbox_IP" {
   value = aws_instance.oobjumpbox.public_ip
 }

 output "ftdv01_IP" {
   value = aws_eip.ftdv01-eip.public_ip
 }
