#!/bin/bash

# Install Apache on Ubuntu
sudo yum check-update
sudo yum -y update
# apache installation, enabling and status check
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd | grep Active
# firewall installation, start and status check
sudo yum install firewalld
sudo systemctl start firewalld
sudo systemctl status firewalld | grep Active
# adding http services
sudo firewall-cmd — permanent — add-service=http
# reloading the firewall
sudo firewall-cmd — reload


sudo cat > /var/www/html/index.html << EOF
<html>
<head>
  <title> Some ordinary application </title>
</head>
<body>
  <p> I love Security of IOT </p>
</body>
</html>
EOF