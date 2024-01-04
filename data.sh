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

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
. ~/.nvm/nvm.sh
nvm install --lts
mkdir ~/myapp
cd ~/myapp
npm init -y
node -e "console.log('Running Node.js ' + process.version)"
npm install express dotenv

cat > app.js << EOF
const express = require("express");
const app = express();

function fibo(n) {
  if (n < 2) return 1;
  else return fibo(n - 2) + fibo(n - 1);
}

app.get("/alive", (req, res) => res.send("Alive!"));
app.get("/", (req, res) => {
  res.send(fibo(req.query.fiboIdx || 40).toString());
});

app.listen(3000, () => console.log(`YoYo server listening on port 3000!`));
EOF
