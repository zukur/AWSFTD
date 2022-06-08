#!/bin/sh

hostnamectl set-hostname srv-b

apt update -y
apt-get install -y apache2
echo "This is my app2" > /var/www/html/index.html
systemctl enable apache2
systemctl start apache2