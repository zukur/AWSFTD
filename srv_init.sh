#!/bin/sh

hostnamectl set-hostname srv

apt update -y
apt-get install -y apache2
echo "This is my app1" > /var/www/html/index.html
systemctl enable apache2
systemctl start apache2